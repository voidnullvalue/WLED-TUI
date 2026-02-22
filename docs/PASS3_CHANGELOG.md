# Pass 3 Refactor + Bugfix Changelog

## Summary
- Scope of this pass: small, audit-backed seams that improve correctness and traceability without changing intended UI behavior.
- Audit findings addressed from `docs/REFACTOR_AUDIT_PASS2.md`:
  - **[High] Discovery parser mismatch in `discover_devices` helper**
  - **[Medium] Device-switch side effects duplicated across handlers**
  - **[Medium] Mixed string/boolean representation for power defaults**

## Changes by Area
### 1) Discovery parsing boundary hardening
- Files changed: `lib/discover.sh`, `wledtui`, `docs/CALL_FLOWS.md`
- Functions changed: `parse_discovery_entry` (new), `discover_devices`, `process_discover_results`
- Why:
  - Discovery lines were parsed in multiple places with fragile assumptions.
  - Audit identified a confirmed field mismatch bug in one consumer.
- What was refactored:
  - Added a shared `parse_discovery_entry` helper that validates field shape and port validity.
  - Updated discovery consumers to use the shared parser.
- Bugfixes included:
  - Fixed `discover_devices` to correctly parse four fields (`name|host|addr|port`) before calling `model_add_device`.
  - `process_discover_results` now skips malformed lines safely and logs a low-noise debug message.
- Behavior preserved:
  - Scan remains manual (`s`) with same primary/fallback discovery strategy.
  - Successful discovery still adds devices and schedules initial fetches.
- Risks / tradeoffs:
  - Malformed entries are now dropped explicitly instead of potentially being misinterpreted.

### 2) Device-selection transition seam
- Files changed: `wledtui`, `docs/CALL_FLOWS.md`, `docs/KEYBIND_MAP.md`
- Functions changed: `on_selected_device_changed` (new), `select_device_delta` (new), `handle_key`, `handle_up`, `handle_down`
- Why:
  - Device change logic was duplicated across key paths and vulnerable to drift.
- What was refactored:
  - Centralized selection mutation, list/topbar updates, and tab-specific side effects into one hook.
  - Updated `[`/`]` and default `↑`/`↓` paths to use the shared helper.
- Bugfixes included:
  - Eliminates branch drift risk where one navigation path could miss tab refresh/fetch behavior.
- Behavior preserved:
  - Existing keybindings and tab behavior are unchanged from a user perspective.
- Risks / tradeoffs:
  - Helper now owns several side effects; future edits should remain confined there.

### 3) Boolean default normalization
- Files changed: `lib/model.sh`, `docs/STATE_AND_CACHE.md`
- Functions changed: `model_add_device`
- Why:
  - Audit noted mixed `0` vs `true/false` representations for power state.
- What was refactored:
  - New devices initialize `DEV_ON` as `false`.
- Bugfixes included:
  - Reduces brittle string/boolean comparisons in display and desired-state sync paths.
- Behavior preserved:
  - Devices still default to off before first successful state fetch.
- Risks / tradeoffs:
  - No expected functional regression; representation now matches runtime conventions.

## Validation Performed
- Manual checks run:
  - Syntax validation for modified shell files.
  - Dry smoke run path (`--smoke`) to exercise parse and async queue code paths without touching real devices.
- Scenarios tested:
  - Discovery parser accepts valid lines and rejects malformed lines.
  - Key-driven selection changes route through shared hook without syntax/runtime errors.
  - Model defaults initialize cleanly under `set -u`.
- What remains unverified:
  - End-to-end interactive TUI navigation with live networked WLED devices was not fully exercised in this environment.
  - Real avahi discovery and fallback probe behavior were not validated against a live LAN.

## Remaining High-Priority Items
- Async event append concurrency hardening (`events.queue` write atomicity).
- Consistent user-visible error surfacing for effects/palettes/presets failures.
- Potential cache-write debounce strategy (needs durability tradeoff decision).

## Notes for Next Pass
- Implement async completion normalization seam (single result object + typed error flags).
- Add low-noise per-tab fetch error hints in rendering path.
- Revisit cache save frequency with bounded debounce and explicit flush points.
