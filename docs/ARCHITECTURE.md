# Architecture

See also: [File Map](./FILE_MAP.md), [Function Index](./FUNCTION_INDEX.md), [Call Flows](./CALL_FLOWS.md), [State and Cache](./STATE_AND_CACHE.md).

## System map
- Entry point: `wledtui`.
- Library load order in `wledtui`: `lib/util.sh` → `lib/model.sh` → `lib/api.sh` → `lib/discover.sh` → `lib/ui.sh` (which sources `lib/render.sh`).
- Core runtime loops in [`main_loop`](./FUNCTION_INDEX.md#main_loop):
  1. Poll async network results (`process_network_queue`).
  2. Poll discovery completion (`process_discover_results`).
  3. Update busy/modal state and spinner.
  4. Render full frame if dirty, else dirty rows only.
  5. Read one key with timeout and dispatch in [`handle_key`](./FUNCTION_INDEX.md#handle_key).

## Data flow
Input key -> handler (`handle_*`) -> mutate desired/UI state and/or enqueue async patch -> async curl worker writes spool files -> main loop consumes event queue -> apply parsed response to model globals -> cache save (`model_save_devices`) -> redraw.

## Async model
- GET and POST requests are launched in background subshells (`start_get_request`, `start_presets_request`, `start_patch_send`).
- Workers write status/data files under `$CACHE_DIR/net` and append `(id, type)` to `events.queue`.
- Main thread never blocks on HTTP for normal operation.

## Device model abstraction
- Device identity key is `host:port` from [`device_id`](./FUNCTION_INDEX.md#device_id).
- Per-device state is stored in many associative arrays (`DEV_*`) keyed by `id`.
- `model_add_device` initializes *all* known fields, including async and desired-state trackers.

## Why Bash works here / brittle points
- Works because behavior is mostly orchestration around curl/jq and line-oriented rendering.
- Brittle points:
  - Large shared mutable global state across sourced files.
  - Concurrency via filesystem queues without strong locking for every path.
  - Terminal escape/key handling depends on platform terminal behavior.
  - JSON shape assumptions can fail for unusual WLED payloads.
