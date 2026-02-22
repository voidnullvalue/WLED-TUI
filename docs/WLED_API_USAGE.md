# WLED API Usage

Cross-links: [Function Index](./FUNCTION_INDEX.md), [Call Flows](./CALL_FLOWS.md).

## Endpoint inventory

| Endpoint | Method | Functions | Fields consumed / payload written | Notes |
|---|---|---|---|---|
| `/json/info` | GET | `api_get_info`, `start_get_request(...,info,...)`, `api_probe_wled` | reads `.ver`, `.wifi.signal`, `.uptime`, `.name` | Probe requires `ver`, `name`, `leds` keys. |
| `/json/state` | GET | `api_get_state`, `start_get_request(...,state,...)` | reads `.bri`, `.on`, `.ps`, `.transition`, `.nl.on`, `.nl.dur`, `.live`, `.seg[]` | Used for status and segment editing base data. |
| `/json/state` | POST | `api_set_state`, `start_patch_send` | writes patches: `{on}`, `{bri}`, `{ps}`, `{transition}`, `{nl:{on}}`, `{live}`, `{rb:true}`, `{seg:[...]}`, optional `applyAll:true` | Async path is primary in UI. |
| `/json/effects` | GET | `api_get_effects`, `start_get_request(...effects...)` | parsed via `parse_effects_tsv` | Accepts array/object variants. |
| `/json/palettes` | GET | `api_get_palettes`, `start_get_request(...palettes...)` | array entries rendered as names | No extra normalization beyond `jq -r '.[]'`. |
| `/json/presets` | GET | `api_get_presets`, `start_presets_request` | parsed via `parse_presets_tsv` | Fallback to `/presets.json` if empty/fail. |
| `/presets.json` | GET fallback | `api_get_presets`, `start_presets_request` | same as presets parsing | Compatibility fallback retained explicitly. |

## Timeout behavior
- `API_CONNECT_TIMEOUT=1`, `API_MAX_TIME=2` seconds for curl operations.
- Async workers optionally delay by `WLEDTUI_NET_DELAY_MS` before request.

## Error handling
- curl uses `--fail`; non-2xx causes failure.
- State GET failure triggers `apply_state_failure` (offline/stale/backoff).
- Info/effects/palettes/presets failures mostly log/debug and keep last known data.
- JSON parse validation uses `jq -e '.'` before applying state/info.

## Assumptions
- Segments exist at `.seg[]`; per-segment fields `.fx`, `.sx`, `.ix`, `.pal`, `.col[0][0..2]`, `.on`.
- Preset IDs can be numeric or string-like; code branches for `--argjson` vs `--arg`.
- Effects payload may be array/object; parser maps IDs robustly.
