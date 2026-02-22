# State and Cache

Related: [Architecture](./ARCHITECTURE.md), [Function Index](./FUNCTION_INDEX.md).

## Global runtime state
- UI globals: `TAB_INDEX`, `SELECTED_DEVICE_INDEX`, `SHOW_HELP`, `UI_DIRTY`, `MODEL_DIRTY`, `RESIZED`, spinner/modal flags, cached rendered rows.
- Tab selection globals: `PRESET_INDEX`, `EFFECT_INDEX`, `PALETTE_INDEX`, `SEGMENT_INDEX`, `COLOR_CHANNEL`, `EFFECT_PARAM`, `SEG_APPLY_ALL`.
- Async tracking: `DEV_GET_*_INFLIGHT_PID`, `DEV_PATCH_INFLIGHT_PID`, `DEV_PENDING_PATCH`, `DEV_PATCH_DUE_MS`, `DISCOVER_INFLIGHT_PID`.

## Device model containers (`lib/model.sh`)
Associative arrays keyed by `id=host:port` include:
- identity/meta: `DEV_NAME`, `DEV_ALIAS`, `DEV_WLED_NAME`, `DEV_HOST`, `DEV_PORT`, `DEV_IP`
- connectivity/timing: `DEV_ONLINE`, `DEV_LAST_SEEN`, `DEV_NEXT_POLL`, `DEV_BACKOFF`, `DEV_STATE_TS`, `DEV_INFO_TS`, `DEV_STATE_STALE`
- state snapshot: `DEV_STATE_JSON`, `DEV_INFO_JSON`, scalar extracts (`DEV_BRI`, `DEV_ON`, `DEV_PRESET`, `DEV_TRANSITION`, `DEV_NL_ON`, `DEV_NL_DUR`, `DEV_LIVE`, etc.)
- desired UI/optimistic state: `DEV_UI_BRI`, `DEV_DESIRED_*`
- list data caches: `DEV_PRESETS_JSON`, `DEV_EFFECTS_JSON`, `DEV_PALETTES_JSON`, parse-error flags.

## Paths and XDG behavior
- Config dir: `${XDG_CONFIG_HOME:-$HOME/.config}/wledtui`
- Cache dir: `${XDG_CACHE_HOME:-$HOME/.cache}/wledtui`
- Device cache: `$CACHE_DIR/devices.json`
- Cache lock: `$CACHE_DIR/devices.lock`
- Debug log: `$CACHE_DIR/debug.log` when `WLEDTUI_DEBUG=1`
- Network spool dir: `$CACHE_DIR/net`

## Device cache JSON schema
Written by `model_save_devices`:
```json
{
  "devices": [
    {
      "name": "...",
      "mdns_name": "...",
      "alias": "...",
      "wled_name": "...",
      "host": "...",
      "ip": "...",
      "port": 80,
      "last_seen": 0,
      "state": {"...": "..."} | null,
      "state_ts": 0
    }
  ]
}
```

## Cache lifecycle
- Load: on startup (`model_load_devices`).
- Persist: after state changes, discovery additions, info name updates, and explicit save paths.
- Locking: `with_lock` + `flock` used for `devices.json` writes and presets parsing critical sections.

## Stale/offline representation
- Offline: `DEV_ONLINE[id]=0`.
- Stale state: `DEV_STATE_STALE[id]=1` (typically after state request failure while cached state exists).
- Backoff: `DEV_BACKOFF` doubles up to clamp range (2..30 seconds for poll scheduling marker).

## Normalization notes
- `model_add_device` now initializes `DEV_ON` with boolean string `false` (not numeric `0`) to align with runtime boolean comparisons and display helpers.

## Concurrency notes
- Event queue (`events.queue`) is moved atomically before processing; helps reduce interleaving.
- Background workers append lines concurrently without a file lock (**Inference:** append races are unlikely but possible under extreme churn).
