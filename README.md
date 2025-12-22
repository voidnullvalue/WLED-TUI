# WLED TUI

WLED TUI is a multi-device terminal UI for Linux, written in Bash, that controls WLED lights via the WLED JSON HTTP API.

## Overview
WLED TUI provides a full-screen Bash TUI (tput/stty) for discovering and managing multiple WLED instances, switching between devices, and adjusting common WLED state such as power, brightness, presets, effects, palettes, segments, colors, and more.

## Features
- Multi-device support with quick switching and a per-device online/offline indicator.
- Manual device discovery (press `s`) using Avahi (`avahi-browse`), probing `_wled._tcp` first and falling back to `_http._tcp` with a `/json/info` probe.
- Manual device add, edit, and remove (host:port).
- Persistent device cache stored in `~/.cache/wledtui/devices.json` (respects `XDG_CACHE_HOME`).
- Status tab: power toggle and brightness adjustments.
- Presets tab: list and apply presets from `/presets.json` (fallback to `/json/presets`).
- Effects tab: list/apply effects; adjust speed or intensity per segment.
- Palettes tab: list/apply palettes per segment.
- Segments tab: toggle segment on/off, edit primary RGB color, and apply changes to all segments.
- Advanced tab: adjust transition time, toggle nightlight, toggle live mode, and reboot.
- Help overlay and footer key legend.
- Refresh requests are asynchronous; the UI stays responsive and keeps cached state visible while updates arrive.
- Debug logging via `WLEDTUI_DEBUG=1` to `~/.cache/wledtui/debug.log` (respects `XDG_CACHE_HOME`).
- Optional smoke test mode (`./wledtui --smoke HOST:PORT`).

## Startup behavior (no scan on launch)
On startup, WLED TUI **does not** perform any device scan or network/mDNS calls. The UI renders immediately using cached device data from the last session. If no cache exists, the UI shows:

```
No devices yet. Press 's' to scan.
```

## Device discovery (manual)
Discovery is user-initiated only. Press `s` to scan for WLED devices using `avahi-browse`. If no `_wled._tcp` services are found, WLED TUI falls back to `_http._tcp` and probes each candidate with `/json/info` to confirm it is a WLED device.

## Cached state
WLED TUI keeps a persistent cache in `~/.cache/wledtui/devices.json` (`XDG_CACHE_HOME` respected). The cache stores device hostname/IP and the last valid `/json/state` payload per device. Cached state is used for immediate UI rendering and remains visible while background refreshes are in flight. Devices that are offline or stale remain listed with their last known state; they are not auto-deleted.

## Requirements / Dependencies
- `bash`
- `curl`
- `jq`
- `avahi-browse`

## Install
Keep it short—install the dependencies with your distro’s package manager:

```bash
# Debian/Ubuntu
sudo apt-get install -y bash curl jq avahi-utils

# Fedora
sudo dnf install -y bash curl jq avahi-tools

# Arch
sudo pacman -S bash curl jq avahi
```

## Run
```bash
chmod +x ./wledtui
./wledtui
```

## Keybinds
Use the same key labels as the footer legend:

| Key | Action |
| --- | ------ |
| (q) | Quit |
| (tab) | Next tab |
| (shift+tab) | Previous tab |
| (↑/↓) | Move selection (devices or list items) |
| (←/→) | Adjust values (brightness, speed/intensity, RGB channel, transition) |
| (enter) | Apply/toggle (power, preset, effect, palette, segment, nightlight) |
| (r) | Refresh selected device |
| (s) | Scan for WLED devices |
| (a) | Add device (host:port) |
| (d) | Delete device |
| (e) | Edit device (host:port) |
| ([ / ]) | Previous/next device |
| (i) | Toggle effect control (speed/intensity) |
| (c) | Cycle RGB channel in segment color editor |
| (g) | Toggle apply-to-all segments |
| (l) | Toggle live mode |
| (b) | Reboot device |
| (?) | Toggle help overlay |

## Configuration / Files
- `~/.cache/wledtui/devices.json` — cached devices and last known state (uses `XDG_CACHE_HOME` if set).
- `~/.cache/wledtui/debug.log` — debug logs when `WLEDTUI_DEBUG=1` (uses `XDG_CACHE_HOME` if set).

## Troubleshooting
- **Discovery finds nothing**:
  - Ensure `avahi-browse` is installed and in `$PATH`.
  - Check firewall rules for UDP 5353 multicast.
  - If devices are on another VLAN/subnet, enable an mDNS reflector or move devices to the same L2 segment.
- **Device shows offline / timeouts**:
  - Verify the device IP/port in `devices.json` or re-add it.
  - WLED TUI uses short HTTP timeouts; intermittent Wi-Fi can cause temporary offline status and exponential backoff.
- **Keys not working in some terminals**:
  - Some terminals remap or delay escape sequences; try a different terminal or SSH client if arrow keys or Shift-Tab do not register correctly.

## Limitations
- Discovery relies on Avahi; without it, devices must be added manually.
- Only the WLED JSON HTTP API is supported (`/json/state`, `/json/info`, `/json/effects`, `/json/palettes`, `/presets.json`/`/json/presets`).
