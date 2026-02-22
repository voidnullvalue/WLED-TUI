# Error Handling and Limitations

## Implemented handling
- HTTP failures for state GET call [`apply_state_failure`](./FUNCTION_INDEX.md#apply_state_failure): marks offline/stale and increases backoff.
- Refresh modal error path: failed selected-device state fetch sets `UI_BUSY_REFRESH_ERROR` and shows "Refresh failed.".
- Discovery failure while busy scan shows "Scan failed." modal.
- Presets endpoint fallback `/json/presets` -> `/presets.json` in both sync and async paths.
- JSON validation before applying state/info (`jq -e '.'`).
- Host/port validation before adding devices or probing.
- Terminal cleanup on exit via trap (`ui_restore`).

## Known gaps / edge cases
- Effects/palettes/presets fetch failures usually do not surface user-visible error beyond missing data.
- Async event append has no explicit lock (`events.queue`) (**Inference**: small race risk).
- Offline/backoff logic impacts scheduling metadata, but explicit periodic poll trigger is mostly manual/refresh-driven.
- Single ESC key has no explicit action.
- Cache corruption silently ignored in many paths (`2>/dev/null`, `|| true`).

## Retry/backoff specifics
- `DEV_BACKOFF` starts at 2s, doubles on state failure, clamp input 2..30 before doubling.
- PATCH sends for offline devices are delayed using backoff-derived `offline_delay_ms`.

## Potential improvements (grounded)
- Surface parse/network errors in UI for effects/palettes/presets tabs.
- Add lock/atomic append strategy for `events.queue` writes.
- Add startup dependency checks with actionable messages.
- Add periodic auto-refresh scheduler using `DEV_NEXT_POLL` consistently.
