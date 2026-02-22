# Internal Protocols

## Net spool protocol (`$CACHE_DIR/net`)
- Data file: `<device_key>.<type>.json`
- Status file: `<device_key>.<type>.status`
- Status line format: `<exit_code> <unix_ts> <http_status> <bytes>`
- Event queue line: `<device_id>\t<type>` appended to `events.queue`

Types: `state`, `info`, `presets`, `effects`, `palettes`.

## Discovery spool protocol
- `discover.results` lines: `name|host|addr|port`
- `discover.status` line: `<exit_code> <unix_ts>`

## In-memory patch queue protocol
- `DEV_PENDING_PATCH[id]` holds merged JSON object.
- Merge operation uses `jq -s '.[0] * .[1]'` (last write wins per key/object path).
- Dispatch gated by debounce/min-interval and offline delay logic.
