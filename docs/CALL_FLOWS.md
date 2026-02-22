# Call Flows

Cross-links: [Function Index](./FUNCTION_INDEX.md), [WLED API Usage](./WLED_API_USAGE.md), [Keybind Map](./KEYBIND_MAP.md).

## Startup flow
1. `wledtui` loads libs and initializes globals.
2. [`main_loop`](./FUNCTION_INDEX.md#main_loop) runs [`model_load_devices`](./FUNCTION_INDEX.md#model_load_devices).
3. If cached state exists for selected device, loads segment list from `.seg[]`.
4. Sets `DEVICE_LIST_DIRTY=1`, initializes terminal via [`ui_init`](./FUNCTION_INDEX.md#ui_init), registers `WINCH` resize trap.
5. Enters non-blocking loop.

**Inference:** No auto-discovery on launch; scan begins only when key `s` triggers [`begin_busy_scan`](./FUNCTION_INDEX.md#begin_busy_scan).

## Manual discovery flow (`s`)
`handle_key('s')` -> `begin_busy_scan` -> `start_discover_scan` (background) -> `discover_devices_report`.

Discovery sequence:
- Primary: `_wled._tcp` via `avahi-browse -rtp`.
- If none found: fallback `_http._tcp`, then probe each candidate via `/json/info` (`api_probe_wled`).
- Results saved to `discover.results`; status to `discover.status`.
- Main loop calls `process_discover_results`, parses each line via `parse_discovery_entry`, adds devices (`model_add_device`), schedules initial async fetches.
- Malformed discovery lines are skipped and debug-logged instead of being applied.

## Device switch flow (`[` / `]` or up/down in default tabs)
- `select_device_delta` clamps movement bounds and delegates transition work to `on_selected_device_changed`.
- `on_selected_device_changed` updates selection/topbar and performs tab-specific side effects.
- This unifies behavior for `[` / `]` and default-tab `↑`/`↓` paths.

## Refresh flow (`r`)
`handle_key('r')` -> `begin_busy_refresh(id)` -> schedules `state/info/presets/effects/palettes` GETs.
- Busy modal persists until `state` inflight PID clears (`update_busy_states`).
- Errors on state fetch set `UI_BUSY_REFRESH_ERROR` and modal "Refresh failed.".

## Preset/effect/palette apply
- Preset Enter (`TAB_INDEX=1`): selected preset id -> enqueue JSON patch `{ps:...}`.
- Effect Enter (`TAB_INDEX=2`): updates selected segment `.fx`, enqueues `{seg:[{id,fx}]}` (+ `applyAll:true` if enabled).
- Palette Enter (`TAB_INDEX=3`): enqueues `{seg:[{id,pal}]}`.

## Segment edit + apply-to-all
- `TAB_INDEX=4`.
- Left/right adjusts RGB component from `COLOR_CHANNEL`; `c` cycles channel.
- Enter toggles segment `.on`.
- `g` toggles `SEG_APPLY_ALL`; patch payloads add `applyAll:true`.

## Advanced actions
- Advanced tab Enter toggles nightlight `{nl:{on:...}}`.
- Global `l` toggles live mode `{live:...}`.
- Global `b` asks confirmation, then enqueues reboot `{rb:true}`.

## Shutdown / terminal restore
- `q` exits process.
- `ui_init` sets `trap 'ui_restore' EXIT INT TERM`.
- `ui_restore` executes `stty echo` and `render_shutdown` (show cursor + leave alternate screen).

## Async queue sequence diagram
```text
Key handler -> enqueue_patch -> DEV_PENDING_PATCH[id]
main_loop -> process_patch_queue -> start_patch_send (&)
worker curl -> exits
main_loop -> process_patch_queue -> clears DEV_PATCH_INFLIGHT_PID

schedule_*_fetch -> start_get_request (&)
worker curl -> writes *.json + *.status + events.queue line
main_loop -> process_network_queue -> process_get_result -> apply_*_response/failure
```
