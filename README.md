# WLED-TUI

WLED-TUI is a **Linux terminal UI written in Bash** for controlling one or more WLED devices over WLED’s JSON HTTP API (`/json/*`). It is an interactive foreground TUI process (alternate screen + key loop), not a background service. It is **not** a Home Assistant integration, **not** MQTT-based control, **not** UDP realtime/E1.31/DDP control, **not** a web UI, and **not** a daemon.

## 1) Feature overview (current behavior)

- Multi-device registry and left-pane device list (persisted across runs).
- Manual discovery (`s`) using Avahi mDNS browse + HTTP probe fallback.
- Manual add/edit/delete of devices as `host:port`.
- Device switching (`[` and `]`) with per-device cached state.
- Online/offline + stale-state behavior (cached state kept visible when fetch fails).
- Tabs: `STATUS`, `PRESETS`, `EFFECTS`, `PALETTES`, `SEGMENTS`, `ADVANCED`.
- Help overlay (`?`) generated from an internal keybinding map.
- Async network model: GET/POST jobs run in background and UI polls spool outputs.
- Persistent config + cache files under XDG paths.
- Optional debug log (`WLEDTUI_DEBUG=1`).
- Built-in smoke mode: `./wledtui --smoke HOST:PORT`.

## 2) Requirements

WLED-TUI assumes Linux shell/terminal tooling and HTTP reachability to WLED devices.

| Requirement | Why it is needed |
|---|---|
| `bash` | Runtime language for app and tests. |
| `curl` | HTTP calls to WLED endpoints. |
| `jq` | JSON parse/normalize and cache serialization. |
| `avahi-browse` | mDNS discovery (`_wled._tcp`, `_http._tcp`). |
| `tput`, `stty` | Terminal capability detection/control. |
| `flock` | File locking during cache/preset critical sections. |
| `rg` (ripgrep) | Used by `./tests/run.sh` assertions. |

Distro package names:

```bash
# Debian/Ubuntu
sudo apt-get update
sudo apt-get install -y bash curl jq avahi-utils ripgrep ncurses-bin util-linux

# Fedora
sudo dnf install -y bash curl jq avahi-tools ripgrep ncurses util-linux

# Arch Linux
sudo pacman -S --needed bash curl jq avahi ripgrep ncurses util-linux
```

> WLED devices must be reachable from the machine running WLED-TUI via plain HTTP on the configured port.

## 3) Installation

```bash
git clone https://github.com/voidnullvalue/WLED-TUI.git
cd WLED-TUI
chmod +x ./wledtui
./wledtui
```

## 4) Quick start

1. Start `./wledtui`.
2. If cache/config exists, devices appear immediately from saved data (no startup scan).
3. If no devices exist, press `s` to scan.
4. If discovery finds nothing, press `a` and add `host:port` manually.
5. Switch devices with `[` / `]`.
6. Use tab/shift-tab to navigate STATUS/PRESETS/EFFECTS/PALETTES/SEGMENTS/ADVANCED.
7. Press `r` to refresh selected device.
8. Press `q` to quit.

## 5) Runtime behavior

- Startup does **not** auto-discover; model/cache load happens first.
- Cached `state`/`info` is used for immediate rendering.
- HTTP work is asynchronous (background jobs), not synchronous in key handlers.
- Workers write under `${XDG_CACHE_HOME:-$HOME/.cache}/wledtui/net/`:
  - `*.status`, `*.json`, and queue/event files used by polling logic.
- Main loop polls job completion and queue files; UI loop keeps repainting.
- Interactive controls use optimistic local state (`DEV_DESIRED_*`, `DEV_UI_BRI`) before network confirmation.
- Failed devices remain in registry; marked offline/stale, not auto-removed.
- State fetch uses backoff (`DEV_BACKOFF`) and next-poll scheduling.
- Selected device gets more aggressive refresh scheduling than inactive devices.

## 6) Architecture

| File | Role |
|---|---|
| `./wledtui` | Entrypoint, global runtime state, key dispatch, tab behavior, async scheduling, payload builders, render loop, smoke flow. |
| `./lib/api.sh` | WLED HTTP wrapper, endpoint selection (`ip` preferred), curl timeout policy, request fallback host/ip behavior, probe logic. |
| `./lib/discover.sh` | Avahi discovery parse, primary `_wled._tcp`, secondary `_http._tcp` + verified probe fallback, discovery-to-model import. |
| `./lib/model.sh` | Device registry arrays/maps, identity merge logic, display-name resolution, config/cache load/save, dirty-save debounce. |
| `./lib/render.sh` | Alternate screen rendering, full redraw vs dirty row flush, cursor visibility handling. |
| `./lib/ui.sh` | TUI formatting primitives, colors, list item formatting, terminal init/restore. |
| `./lib/util.sh` | Paths, debug logging, host/port validation, sanitization, locking, jq parser helpers, key reader/prompt helpers. |
| `./tests/run.sh` | Regression checks for endpoints, parsers, name merge behavior, async guardrails, payload details, safety assertions. |

## 7) WLED API usage (exact endpoints)

| Endpoint | Method | Used for |
|---|---|---|
| `/json/info` | GET | device metadata, probe verification, version/name/wifi/uplink fields. |
| `/json/state` | GET | current power/brightness/preset/segment/live/etc state. |
| `/json/state` | POST | all control writes (power, bri, preset, effect, palette, seg, transition, nl, live, reboot). |
| `/json/eff` | GET | effects list. |
| `/json/pal` | GET | palettes list. |
| `/presets.json` | GET | presets primary fetch path. |
| `/json/presets` | GET | presets fallback if `/presets.json` empty/fails. |

POST payloads are always sent to `/json/state`.

## 8) Discovery behavior

- `s` starts scan; no automatic startup scan.
- Primary: `avahi-browse -rtp _wled._tcp`.
- Secondary fallback: `avahi-browse -rtp _http._tcp` + concurrent probe (`WLEDTUI_DISCOVERY_CONCURRENCY`, default `8`).
- Probe acceptance requires `/json/info` JSON containing `ver`, `name`, and `leds` keys.
- Host/port are validated before insertion.
- Discovery tracks `host`, `port`, `ip`, mDNS/service label, and merges MAC/name fields when available.
- Duplicate-avoidance is via model merge precedence: MAC, then `ip:port`, then `host:port`, then friendly-name heuristics by port.
- mDNS is local-network dependent; cross-VLAN discovery needs reflector/routing.
- Manual add remains the reliable fallback when mDNS is unreliable.

## 9) Device identity and naming

- Canonical key is effectively `host:port` (`device_id`).
- Runtime model uses Bash associative arrays keyed by device id (`DEV_*`).
- Tracked identity fields include alias, mDNS name, WLED name, last good WLED name, preferred/stable ID placeholders, host/port/ip/mac.
- Display name precedence implemented by `device_display_name`:
  1. `alias`
  2. non-autogenerated `wled_name`
  3. non-autogenerated `last_good_wled_name`
  4. non-autogenerated mDNS/base name
  5. non-IP host as `host:port`
  6. IP
  7. raw id
- Autogenerated names matching `wled-<hex6|hex12>[.local]` are intentionally de-prioritized.
- Rediscovery merge logic is designed to preserve friendly names/aliases when matching by MAC/IP/host.

## 10) Config, cache, and files

| Path | Purpose |
|---|---|
| `${XDG_CONFIG_HOME:-$HOME/.config}/wledtui/devices.json` | persistent identity/user metadata (alias, names, stable fields, host/ip/port). |
| `${XDG_CACHE_HOME:-$HOME/.cache}/wledtui/devices.json` | runtime-ish cache: last seen, online flag, cached state/info, brightness snapshots. |
| `${XDG_CACHE_HOME:-$HOME/.cache}/wledtui/debug.log` | debug log when `WLEDTUI_DEBUG=1`. |
| `${XDG_CACHE_HOME:-$HOME/.cache}/wledtui/net/` | async spool: request status/results/events/discovery outputs. |
| `${XDG_CACHE_HOME:-$HOME/.cache}/wledtui/devices.lock` | `flock` lock for cache writes. |
| `${XDG_CONFIG_HOME:-$HOME/.config}/wledtui/presets.lock` | lock around presets parse/update section. |

## 11) Environment variables

| Variable | Default | Purpose | Change when… |
|---|---:|---|---|
| `WLEDTUI_DEBUG` | unset (`0` behavior) | Enable debug logging. | You need diagnostics. |
| `WLEDTUI_NET_DELAY_MS` | `0` | Artificial delay before async network worker actions. | Simulating slow network / debugging races. |
| `WLEDTUI_PATCH_DEBOUNCE_MS` | `50` | Coalesce patch writes shortly after interaction. | Tune responsiveness vs write burst. |
| `WLEDTUI_PATCH_MIN_SEND_INTERVAL_MS` | `50` | Minimum interval between sends per device. | Limit patch spam. |
| `WLEDTUI_ACTIVE_WINDOW_MS` | `400` | Treat recent user interaction as active window for refresh logic. | Tune interaction freshness policy. |
| `WLEDTUI_MODEL_SAVE_DEBOUNCE_MS` | `2000` | Debounced model save interval. | Reduce disk writes or force faster persistence. |
| `WLEDTUI_DISCOVERY_CONCURRENCY` | `8` | Parallel probes in secondary discovery verification. | Tune scan speed vs network load. |
| `WLEDTUI_INTERACTIVE_TT` | `0` | `tt` field injected into interactive payload helpers. | Use nonzero WLED transition time on direct tweaks. |
| `WLEDTUI_ASYNC_DRY_RUN` | unset | Skip real async HTTP writes in dry-run/test paths. | Internal testing/smoke/debug. |
| `XDG_CONFIG_HOME` | `$HOME/.config` | Root for config file location. | Custom config layout. |
| `XDG_CACHE_HOME` | `$HOME/.cache` | Root for cache/debug/net spool files. | Custom cache layout. |

## 12) Keybindings

Derived from `KEYBINDINGS` + actual key dispatch.

| Key | Scope | Behavior |
|---|---|---|
| `q` | Global | Quit. |
| `?` | Global | Toggle help overlay. |
| `Tab` | Global | Next tab. |
| `Shift-Tab` (`ESC[Z` / `ESC[1;2Z`) | Global | Previous tab. |
| `r` | Global | Refresh selected device (schedules GETs). |
| `s` | Global | Start discovery scan. |
| `l` | Global | Toggle live mode patch for selected device. |
| `b` | Global | Reboot selected device (confirm). |
| `a` | Devices pane | Add `host:port`. |
| `d` | Devices pane | Delete selected device (confirm). |
| `e` | Devices pane | Edit selected device endpoint. |
| `[` / `]` | Devices pane/global | Previous/next device selection. |
| `↑` / `↓` | Lists/context | Move selection. |
| `Enter` | Contextual | Apply/toggle tab action. |
| `←` / `→` | STATUS/EFFECTS/SEGMENTS/ADVANCED | Adjust value. |
| `i` | EFFECTS tab | Toggle speed/intensity target. |
| `c` | SEGMENTS tab | Cycle RGB channel focus. |
| `g` | SEGMENTS tab | Toggle apply-to-all segments. |

## 13) Tab-by-tab behavior

- **STATUS**: power on/off + brightness; left/right changes brightness using optimistic UI and async patch.
- **PRESETS**: fetch from `/presets.json` with fallback `/json/presets`; IDs/names parsed via `parse_presets_tsv`; enter applies preset id.
- **EFFECTS**: fetch `/json/eff`; parser supports array/object forms, filters `RSVD` and `-` while preserving original IDs; enter applies effect, left/right edits speed/intensity.
- **PALETTES**: fetch `/json/pal`; list and apply selected palette id.
- **SEGMENTS**: segment list from state JSON, toggle segment on/off, edit primary `col[0]` RGB (and preserve W channel when present), optional apply-all payload flag.
- **ADVANCED**: transition adjustment, nightlight toggle, live mode toggle, reboot action.

## 14) Performance model

- Non-blocking design prevents per-key HTTP stalls.
- Async curl workers + spool files + polled event queue decouple network latency from render/input loop.
- Cached model/state enables immediate render and tab navigation even while offline.
- Optimistic updates keep controls feeling responsive.
- Debounced/coalesced patch writes reduce network chatter.
- Minimum send interval throttles rapid repeat writes.
- Short curl timeouts bound worst-case wait in worker jobs.
- Backoff reduces repeated failures against offline devices.
- Selected device refresh preference improves perceived responsiveness.
- Presets/effects/palettes are cached per device and reused until refreshed.

## 15) Error handling and offline behavior

- Curl policy from `lib/api.sh`: `--connect-timeout 1`, `--max-time 2`, `--fail`.
- `/json/state` failure marks device offline and stale (if cached state exists), then applies backoff scheduling.
- Info/effects/palettes/presets fetch failures keep previous cached values and log details in debug mode.
- Malformed JSON is rejected via `jq` checks before model mutation.
- Effects parse failures surface in UI hints (“enable `WLEDTUI_DEBUG=1`”).
- Error modal/busy status indicators are used for scan/refresh visibility and transient failures.

## 16) Security/safety notes (defensive, not “secure by magic”)

Implemented hardening includes:

- Host validation (`is_valid_host`) and port validation (`is_valid_port`) before URL construction.
- Curl uses `--` URL terminator to avoid option-injection via endpoint text.
- UI text is sanitized (`strip_ansi`, control-char removal) before rendering/prompts/title.
- JSON normalization helper (`json_normalize_or_fail`) used before applying critical data.
- Cache writes are direct `printf` writes; no shell eval of cached JSON.
- `flock` guards shared writes/critical regions (`devices.lock`, `presets.lock`).

## 17) Troubleshooting

### Discovery finds nothing
```bash
command -v avahi-browse
avahi-browse -rtp _wled._tcp
avahi-browse -rtp _http._tcp
```
If empty, add manually with `a` (`host:port`). Cross-VLAN discovery usually needs mDNS reflection.

### Device shows IP/generated `wled-*` name
Friendly display-name priority may fall back to host/IP when better names are missing or autogenerated.

### Duplicate devices after rediscovery
Check if device MAC/IP changed; merge logic primarily matches by MAC and endpoint tuples.

### Cached state looks stale
Use `r` for selected device refresh; stale cached state is intentionally retained when offline.

### Presets/effects/palettes blank
Check raw API:
```bash
curl http://DEVICE:PORT/json/info
curl http://DEVICE:PORT/json/state
curl http://DEVICE:PORT/json/eff
curl http://DEVICE:PORT/json/pal
curl http://DEVICE:PORT/presets.json
```

### Controls feel delayed
Tune:
- `WLEDTUI_PATCH_DEBOUNCE_MS`
- `WLEDTUI_PATCH_MIN_SEND_INTERVAL_MS`
- `WLEDTUI_NET_DELAY_MS`

### Offline/timeouts
Verify routing/firewall/Wi-Fi stability; timeouts are intentionally short.

### Debug logging
```bash
WLEDTUI_DEBUG=1 ./wledtui
tail -f "${XDG_CACHE_HOME:-$HOME/.cache}/wledtui/debug.log"
```

### Inspect cache/config JSON
```bash
jq . "${XDG_CONFIG_HOME:-$HOME/.config}/wledtui/devices.json"
jq . "${XDG_CACHE_HOME:-$HOME/.cache}/wledtui/devices.json"
```

### Reset cache/config safely
```bash
mv "${XDG_CONFIG_HOME:-$HOME/.config}/wledtui/devices.json"{,.bak.$(date +%s)} 2>/dev/null || true
mv "${XDG_CACHE_HOME:-$HOME/.cache}/wledtui/devices.json"{,.bak.$(date +%s)} 2>/dev/null || true
```

## 18) Development workflow

### Run tests
```bash
./tests/run.sh
bash -n ./wledtui ./lib/*.sh ./tests/run.sh
```

### Test coverage (high-level)
- endpoint strings and API path correctness
- parser behavior for effects/presets
- malformed JSON rejection
- naming/merge behavior and friendly-name preservation
- RGBW white-channel preservation
- async skip/guard behavior under no-device and failure scenarios
- safety assertions around curl invocation patterns

### Style expectations for contributors/LLM agents
- Keep strict Bash mode semantics (`set -euo pipefail`).
- Avoid command-substitution around mutating functions when array/global mutation is required.
- Preserve friendly-name merge/display behavior.
- Preserve original WLED numeric IDs for effects/presets.
- Preserve RGBW white channel when editing colors.
- Keep network I/O async/non-blocking where existing design depends on it.
- Validate host/port before building URLs.

## 19) Known limitations

- Linux terminal-focused workflow and dependencies.
- Requires HTTP reachability to WLED devices.
- Discovery quality depends on local mDNS/Avahi behavior.
- No MQTT mode.
- No Home Assistant OS integration mode.
- No UDP realtime/E1.31/DDP control path in this project.
- No built-in auth/TLS/session handling in API wrapper.
- Bash TUI/key-sequence portability limits apply.
- WLED firmware/schema variations may degrade parsing for uncommon payloads.

## 20) FAQ

**Why no scan on startup?**  
To keep startup deterministic and instant from cache; scanning is explicit (`s`).

**Why show cached devices while offline?**  
The model intentionally preserves known devices + last state for continuity and recovery.

**Why did name change to IP or `wled-*`?**  
Friendly naming is best-effort with de-prioritization rules; fallback may occur when richer identity data is unavailable.

**How do I clear cache?**  
Back up then move/remove XDG `devices.json` files (see troubleshooting reset commands).

**How do I manually add a device?**  
Press `a`, enter `host:port` or `ip:port`.

**Why are effects/palettes empty?**  
The endpoint may fail/timeout or payload shape may not parse as expected; verify with `curl` and enable debug logs.

**How do I get logs?**  
Run with `WLEDTUI_DEBUG=1`; inspect `${XDG_CACHE_HOME:-$HOME/.cache}/wledtui/debug.log`.

**macOS/Windows/WSL support?**  
Not a primary target. It may run in compatible environments (especially Linux-like shells such as WSL) if dependencies and terminal behavior match, but repository assumptions/dependencies are Linux-centric.
