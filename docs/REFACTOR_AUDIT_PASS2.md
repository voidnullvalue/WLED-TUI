# Refactor Audit (Pass 2): Intent vs Implementation

## 1) Scope and Sources Reviewed

### Files reviewed
- `wledtui` (main control loop, async queueing, rendering composition, key dispatch, device operations).
- `lib/model.sh` (device state model, cache load/save, identity and mutation helpers).
- `lib/api.sh` (HTTP wrappers, timeout policy, probe semantics).
- `lib/discover.sh` (Avahi parsing, primary/fallback discovery behavior).
- `lib/util.sh` (locking, input parsing, sanitization, helpers).
- `lib/ui.sh`, `lib/render.sh` (terminal mode and rendering primitives).

### docs/ reviewed
- `docs/FUNCTION_INDEX.md`
- `docs/CALL_FLOWS.md`
- `docs/WLED_API_USAGE.md`
- `docs/STATE_AND_CACHE.md`
- `docs/KEYBIND_MAP.md`
- `docs/ERROR_HANDLING_AND_LIMITATIONS.md`
- `docs/ARCHITECTURE.md`
- `README.md`

### Limitations / ambiguities
- No automated test suite exists; conclusions are from static analysis + behavior implied by call flow docs.
- Some generated docs mark behaviors as inference; where docs and code differ, code was treated as source of truth.
- Runtime race severity is assessed from Bash/file semantics; exact frequency requires stress runs.

## 2) Project Intent (Restated)

In practical engineering terms, the project intends to:
- Render immediately from cache without startup network delay.
- Keep TUI responsive by offloading network to background jobs.
- Maintain predictable, context-correct key behavior with clear help/footer guidance.
- Keep per-device state coherent across optimistic UI updates, async confirmations, and cache persistence.
- Discover and manage multiple devices reliably (manual scan/add/edit/delete) without silent state corruption.
- Fail gracefully on network/API/JSON problems while preserving terminal integrity and user context.
- Stay maintainable as a Bash codebase by reducing hidden coupling and clarifying mutation boundaries.

## 3) Executive Summary

### Top 5 highest-value refactor targets (bugfix-oriented)
1. **Standardize async event + status consumption paths** (single parser/result object) to reduce stale-state and partial-update bugs.
2. **Introduce explicit state mutation seams** for “known state”, “desired state”, and “UI transient” to reduce accidental cross-effects.
3. **De-duplicate device-switch and tab-entry logic** currently repeated across `handle_key`, `handle_up`, and `handle_down`.
4. **Harden discovery result parsing and duplicate handling** so malformed lines or weird Avahi names do not produce brittle behavior.
5. **Make failure surfacing consistent across tabs** (presets/effects/palettes failures are mostly debug-log only today).

### Top 5 “don’t touch casually” areas (high coupling / high regression risk)
1. `main_loop` and `build_frame` interaction (dirty/full redraw pathways).
2. `process_network_queue` + `process_get_result` + PID clearing lifecycle.
3. `sync_desired_from_known` timing logic (`UI_ACTIVE_WINDOW_MS`) protecting optimistic edits.
4. `model_add_device` initialization contract (many arrays rely on this being complete).
5. Terminal lifecycle (`ui_init` trap + `render_shutdown`) where small mistakes can leave terminal broken.

### Overall risk assessment for a third-pass refactor: **Medium-High**
Rationale: behavior is relatively coherent, but heavy global-state coupling and async filesystem choreography create non-local side effects. Small structural changes can cascade unless done in narrow seams with validation after each step.

## 4) Intent vs Implementation Matrix

| Intended Outcome | Current Implementation (functions/files) | Strengths | Gaps / Risks | Severity | Refactor Opportunity | Notes |
|---|---|---|---|---|---|---|
| Reliable discovery and selection | `discover_devices_report`, `process_discover_results`, `model_add_device` | Primary `_wled._tcp` + fallback probe path; host/port validation exists | Discovery output is plain delimited text; no explicit dedupe layer during one scan; parsing relies on Avahi format assumptions | High | Extract discovery record parser + dedupe/normalization helper | Preserve manual scan-only behavior |
| Responsive rendering | `main_loop`, `build_frame`, `render_draw_frame`, `render_flush_dirty` | Async network and dirty-row rendering reduce blocking | `build_frame` is large/multi-responsibility; partial updates mixed with data prep can hide ordering bugs | Medium | Split frame composition by pane/tab with pure builders | Likely intentional optimization; keep dirty-row path |
| Correct keybinding behavior | `read_key`, `handle_key`, `handle_up/down/left/right/enter` | Context-aware mappings broadly match docs; shift-tab support included | Repeated switch/device logic across handlers risks drift; single ESC ignored implicitly | Medium | Centralize dispatch table + shared “on device changed” hook | ESC ignore appears likely intentional |
| Stable async refresh without races | `start_get_request`, `process_network_queue`, `process_get_result`, `update_busy_states` | Non-blocking fetch/apply loop; state failure marks stale/offline | `events.queue` append has no lock; workers for same id/type can overwrite same files if future scheduling changes | High | Introduce per-request token/sequence and unified completion object | Current inflight guards lower risk but not complete future-proofing |
| Safe state mutation/cache persistence | `apply_state_response`, `sync_desired_from_known`, `model_save_devices` | Cache persisted often; stale marker model is explicit | `model_save_devices` called on each state apply can cause high churn; state mutation spread across many functions | Medium | Create explicit mutation API (`set_known_state`, `set_desired_state`) | Behavior should remain immediate-save unless intentionally changed |
| Robust API interactions | `api_request`, `api_probe_wled`, async curl workers | Short timeouts and `--fail`; JSON validity checks before apply | Retries/backoff only strongly tied to state endpoint; non-state failures mostly silent in UI | Medium | Normalize API result statuses and user-facing tab-level error flags | Keep existing timeout defaults unless justified |
| Graceful error handling + cleanup | `apply_state_failure`, modal errors, `ui_restore` trap | Terminal restore on EXIT/INT/TERM; refresh/scan modal errors shown | Parse errors often debug-only; prompt/read path assumes tty available | Medium | Consolidate error taxonomy and display policy | Cleanup path is mostly solid and should be minimally touched |
| Maintainable Bash for future edits | Entire codebase | Consistent helper usage (`clamp`, `with_lock`, sanitization) | Large monolithic functions and many globals increase cognitive load and regression risk | High | Refactor by seams around dispatch/parsing/state mutation, not rewrites | Do not rewrite language; improve boundaries incrementally |

## 5) Best-Practice Evaluation by Category (Bash + TUI + Networked App)

### 5.1 Function Design and Cohesion

**Strengths**
- Reasonable helper extraction for low-level utilities (`clamp`, `with_lock`, parsers).
- Async worker launch functions are separated from apply logic.

**Weak areas and seams**
1. `build_frame` (very broad responsibilities: layout, per-tab data decisions, overlay composition).
   - Why it impedes bugfixing: render bugs and data-prep bugs are intertwined.
   - Refactor seam: split into `compose_left_pane`, `compose_right_pane_for_tab`, `compose_overlays` pure-ish helpers.
2. `handle_key` + `handle_up/down` duplicate device-switch side effects.
   - Why it impedes bugfixing: key behavior changes need edits in multiple branches.
   - Refactor seam: a single `on_selected_device_changed(old,new)` helper.
3. `process_get_result` mixes transport status parsing, validation, model apply, and PID cleanup.
   - Why it impedes bugfixing: difficult to reason about failure paths.
   - Refactor seam: first parse status into a typed shell struct (associative array prefix) then route.

### 5.2 State Management and Global Variables

**Strengths**
- `model_add_device` initializes broad per-device fields, reducing unbound-variable failures under `set -u`.
- Explicit stale/offline fields (`DEV_STATE_STALE`, `DEV_ONLINE`) are conceptually clear.

**Hotspots / risks**
- `DEV_DESIRED_*`, `DEV_UI_BRI`, and known state (`DEV_*`) are mutated across many handlers and apply functions.
- Implicit transitions: `sync_desired_from_known` can overwrite optimistic values based on timing windows.
- UI tab/list indices are global and context-coupled to loaded arrays; switching devices/tabs can temporarily point at stale indices (mostly clamped, but logic is scattered).

**Refactor seam**
- Centralize writes through explicit helpers:
  - known state updates from API
  - desired state updates from user input
  - ephemeral UI-only values
- Add lightweight invariants (e.g., index clamp helper invoked on tab/device switch).

### 5.3 Input Handling and Keybinding Dispatch

**Strengths**
- `read_key` handles CSI-style sequences and timeout-based nonblocking input.
- Dispatch includes explicit shift-tab variants and Enter variants.

**Risks**
- Single ESC path is effectively dropped (likely intentional, but undocumented in UI).
- Key->behavior mapping is partially declarative (`KEYBINDINGS`) but execution is manual `case`; mismatch risk remains.

**Refactor seam**
- Keep existing `case` behavior but route through a small key-action map for shared operations (tab switch, device switch, per-tab fetch hooks).

### 5.4 Rendering Architecture (TUI)

**Strengths**
- Dirty-row rendering and full redraw fallback are pragmatic for Bash.
- Terminal alternate-screen + cursor hiding/restoration implemented.

**Risks**
- Partial update helpers (`update_inner_row`, etc.) assume frame geometry already correct; ordering bugs possible near resize/device switch churn.
- `build_frame` repeatedly duplicates right-pane list population logic that already exists in build_* helpers.

**Refactor seam**
- Reduce duplicated list rendering by always using tab-specific builders, then optionally dirty-update rows.
- Keep full redraw fallback as safety path.

### 5.5 WLED API Integration

**Strengths**
- Consistent timeout policy and curl option hardening (`--` before URL).
- `/json/presets` fallback to `/presets.json` in sync and async flows.
- JSON validity checked before state/info apply.

**Risks**
- Non-state endpoint failures (effects/palettes/presets) are under-reported to user.
- Payload construction is distributed across handlers; easy to introduce inconsistent shapes.

**Refactor seam**
- Extract payload builders (`payload_set_bri`, `payload_set_seg_fx`, etc.) to one section to reduce drift.
- Standardize endpoint result status flags for UI display.

### 5.6 Discovery and Device Management

**Strengths**
- User-initiated-only scan aligns with startup responsiveness goal.
- Fallback probing helps on networks without `_wled._tcp`.
- Manual add/edit/delete path validates host/port.

**Risks**
- Discovery data exchanged as `name|host|addr|port`; fragile if upstream format unexpectedly contains delimiters or missing fields.
- `process_discover_results` directly adds + schedules fetch in one loop, hard to isolate bugs in add vs fetch scheduling.

**Refactor seam**
- Introduce `parse_discovery_entry` + `normalize_discovered_device` + `apply_discovery_results` split.

### 5.7 Async/Background Job Behavior

**Strengths**
- Inflight PID guards avoid duplicate fetch scheduling per id/type.
- Event queue is atomically moved before processing.

**Identified risks (with scenario/symptom/debug impact/strategy)**
1. **Event append concurrency**
   - Trigger: multiple worker completions append to `events.queue` simultaneously.
   - Symptom: rare malformed/merged lines could skip a completion.
   - Debug difficulty: transient and timing-dependent.
   - Strategy: append via per-write lock or per-event temp file + concatenation.
2. **Status/data overwrite possibility by same id/type**
   - Trigger: if scheduling guards regress or future features add forced refresh overlap.
   - Symptom: stale completion applied as latest.
   - Debug difficulty: appears as random rollback.
   - Strategy: add request sequence token included in filenames and events.
3. **Busy refresh completion tied only to state PID** (likely intentional)
   - Trigger: info/presets still running when state done.
   - Symptom: busy modal clears early relative to other tabs.
   - Debug difficulty: can look inconsistent but matches current design comment.
   - Strategy: document as intentional, or later configurable “strict refresh”.

### 5.8 Error Handling and Recovery

**Strengths**
- State failures drive visible offline/stale indicators and backoff.
- Scan and refresh failures surface modal errors.
- Terminal restore trap exists in UI init.

**Risks**
- Parse errors in effects/palettes/presets mostly rely on debug logs.
- Cache read errors are often silently swallowed (`2>/dev/null`, `|| true`), good for resilience but poor diagnosability.

**Refactor seam**
- Add low-noise user-visible status lines per tab (e.g., “last fetch failed”) while preserving non-blocking behavior.

### 5.9 Shell Safety / Portability Practices

**Observed good practice**
- Strong quoting and input validation are generally present.
- Uses `set -euo pipefail`; most risky commands guarded with conditionals/`|| true`.
- `with_lock` with `flock` for cache write critical sections.

**Bash-specific constraints and fit**
- `set -u` is workable because arrays are broadly initialized; however, high global coupling means missing initialization in new fields would fail hard.
- `set -e` in interactive loops is mitigated but future edits must preserve conditional patterns (e.g., command substitutions need care).
- `pipefail` is acceptable here due to explicit error suppression where intended.
- GNU assumptions exist (`date +%s%3N`, `flock`, `tput` behavior), matching stated Linux target.

**Conclusion on `set -euo pipefail`**
- Appropriate for this repo **as currently written**, but third-pass refactor should avoid introducing unguarded command substitutions in hot paths.

## 6) Confirmed Issues and Likely Bugs (Bugfix-Oriented)

### [High] Discovery parser mismatch in `discover_devices` helper
- Type: Confirmed Issue
- Intended outcome impacted: reliable WLED device discovery and selection
- Evidence (file/function/behavior): `discover_devices_report` emits `name|host|addr|port`, but `discover_devices` reads only `name|host|port` and passes third field as port.
- Why this is a problem: if `discover_devices` is used, port parsing is wrong (addr consumed as port).
- Minimal safe fix direction: parse four fields consistently (`name host addr port`) and pass correct `port`.
- Refactor-prep step (if needed before fix): add shared parser helper used by both discovery consumers.
- Regression risk: Low (function appears currently unused in main flow).
- Suggested validation steps: run discovery path and assert stored `DEV_PORT` numeric for discovered devices.

### [High] State apply performs frequent full cache writes
- Type: Likely Risk
- Intended outcome impacted: responsive terminal UI rendering; safe state mutation and cache persistence
- Evidence (file/function/behavior): `apply_state_response` calls `model_save_devices` on every successful state apply.
- Why this is a problem: high-frequency refreshes across multiple devices can create disk churn and make debugging timing issues harder.
- Minimal safe fix direction: debounce/batch saves (e.g., dirty flag + periodic flush) while keeping eventual persistence.
- Refactor-prep step (if needed before fix): introduce dedicated cache-persistence scheduler.
- Regression risk: Medium (must preserve crash-recovery expectations).
- Suggested validation steps: compare persisted cache freshness before/after rapid refresh loops.

### [Medium] Mixed string/boolean representation for power defaults
- Type: Likely Risk
- Intended outcome impacted: safe state mutation and correctness
- Evidence (file/function/behavior): `model_add_device` sets `DEV_ON[$id]="0"`, while runtime comparisons expect `true/false` strings.
- Why this is a problem: although behavior currently tends to “off”, mixed representation increases conditional brittleness and future bug probability.
- Minimal safe fix direction: standardize to `false` for unset/off boolean-like fields.
- Refactor-prep step (if needed before fix): add normalization helper for boolean fields during model init/load.
- Regression risk: Low-Medium.
- Suggested validation steps: verify status tab power toggle and device list marker before/after first state fetch.

### [Medium] Asymmetric stale handling for non-state fetch failures
- Type: Likely Risk
- Intended outcome impacted: robust API interactions and error handling
- Evidence (file/function/behavior): `process_get_result` applies explicit failure state only for `state`; other types mostly log.
- Why this is a problem: users can see empty lists without context, making operational issues harder to diagnose.
- Minimal safe fix direction: track per-endpoint last-error flags/timestamps and render concise messages.
- Refactor-prep step (if needed before fix): standardize result object from `process_get_result`.
- Regression risk: Low.
- Suggested validation steps: simulate endpoint failures and confirm non-intrusive tab-level error hints.

### [Medium] Device-switch side effects duplicated across handlers
- Type: Likely Risk
- Intended outcome impacted: correct keybinding behavior; maintainability
- Evidence (file/function/behavior): similar selection-change blocks appear in `handle_key` (`[`/`]`) and `handle_up/down` default branches.
- Why this is a problem: future behavior fixes can be applied in one path but missed in others.
- Minimal safe fix direction: single helper to apply selection change + tab refresh hooks.
- Refactor-prep step (if needed before fix): add helper and migrate call sites without behavior changes.
- Regression risk: Medium.
- Suggested validation steps: full keybinding smoke for up/down and [/] across all tabs.

## 7) Refactor Seams for a Third Pass (MOST IMPORTANT)

### Seam A: Async result normalization boundary
- Target files/functions: `wledtui` (`process_network_queue`, `process_get_result`, `start_get_request`, `start_presets_request`)
- Why this seam matters: currently transport parsing and model mutation are intertwined.
- Behavior to preserve exactly: same request schedule timing, same busy modal semantics, same stale/offline behavior for state.
- Expected bugfix leverage: easier to add endpoint-specific error UI and reduce stale overwrite risks.
- Estimated regression risk: Medium.
- Suggested implementation order: first in Phase 1/2 after instrumentation.

### Seam B: Device selection transition hook
- Target files/functions: `handle_key`, `handle_up`, `handle_down`, `refresh_*` helpers
- Why this seam matters: removes duplicated logic and keypath drift.
- Behavior to preserve exactly: current per-tab fetch/refresh side effects on selection change.
- Expected bugfix leverage: keybinding fixes become single-point edits.
- Estimated regression risk: Medium.
- Suggested implementation order: early Phase 1.

### Seam C: State mutation helpers (known vs desired vs UI)
- Target files/functions: `apply_state_response`, `sync_desired_from_known`, `handle_left/right/enter/live`
- Why this seam matters: reduce hidden side effects and timing bugs.
- Behavior to preserve exactly: optimistic UI behavior and `UI_ACTIVE_WINDOW_MS` protections.
- Expected bugfix leverage: safer bugfixes around stale/racy updates.
- Estimated regression risk: Medium-High.
- Suggested implementation order: Phase 2 after logging coverage.

### Seam D: Discovery parsing/normalization split
- Target files/functions: `lib/discover.sh`, `wledtui` discovery handlers
- Why this seam matters: hardens fragile string parsing and duplicate handling.
- Behavior to preserve exactly: manual scan trigger and fallback probe policy.
- Expected bugfix leverage: discovery-related fixes become isolated.
- Estimated regression risk: Low-Medium.
- Suggested implementation order: Phase 1.

### Seam E: Payload builder extraction
- Target files/functions: `handle_left/right/enter`, `handle_live_toggle`, `handle_reboot`
- Why this seam matters: avoids repeated JSON construction logic.
- Behavior to preserve exactly: payload shape and applyAll usage.
- Expected bugfix leverage: fewer accidental schema inconsistencies.
- Estimated regression risk: Low-Medium.
- Suggested implementation order: Phase 2.

## 8) Third-Pass Refactor Plan (Phased)

### Phase 0: Safety net / instrumentation
- Tasks:
  - Add targeted debug markers around selection changes, async completion, and state mutation transitions.
  - Document likely-intent behaviors (e.g., busy refresh clears on state completion only).
- Dependencies: none.
- Success criteria: can trace one full user action (key -> patch/fetch -> apply -> redraw) in logs.
- Rollback notes: instrumentation can be removed independently.

### Phase 1: Lowest-risk structural cleanup
- Tasks:
  - Extract discovery parse/normalize helpers.
  - Introduce shared selected-device-change hook and migrate duplicate branches.
  - Add index clamp helper for tab list indices.
- Dependencies: Phase 0 logging.
- Success criteria: no visible behavior change in manual smoke flows.
- Rollback notes: each extraction should be isolated commits.

### Phase 2: High-value bugfix-oriented refactors
- Tasks:
  - Normalize async result handling with explicit status object.
  - Add endpoint-specific error flags for presets/effects/palettes.
  - Extract payload builders.
- Dependencies: Phase 1.
- Success criteria: failures are visible without debug mode; no key dispatch regressions.
- Rollback notes: keep old apply functions available until parity proven.

### Phase 3: Behavior fixes enabled by earlier refactors
- Tasks:
  - Fix confirmed discovery parse mismatch in `discover_devices`.
  - Standardize boolean field representations in model defaults/load.
  - Consider cache-save debounce with strict durability notes.
- Dependencies: Phase 2 seams.
- Success criteria: targeted bug scenarios fixed with unchanged expected UX elsewhere.
- Rollback notes: keep cache-save strategy behind minimal toggle if needed.

### Phase 4: Optional hardening/cleanup
- Tasks:
  - Improve events queue write atomicity strategy.
  - Reduce `build_frame` duplication by consistently using tab builders.
  - Clean temporary debug markers.
- Dependencies: prior phases stable.
- Success criteria: cleaner code paths with no render regressions under resize/input churn.
- Rollback notes: preserve full redraw fallback.

## 9) What NOT to Refactor Yet

- Do not rewrite terminal mode handling (`ui_init/ui_restore/render_shutdown`) before adding robust manual cleanup tests.
- Do not change refresh completion semantics (state-driven busy clear) without explicit UX decision.
- Do not alter timeout defaults/backoff policy and payload semantics in same PR as structural moves.
- Do not replace Bash with another language in this pass; no blocking reason observed.
- Do not collapse all globals at once; introduce bounded mutation seams first.

## 10) Validation Strategy for Refactor/Bugfix Pass

### Manual smoke tests (per incremental change)
- Startup with/without cache: immediate render and no startup scan.
- Device navigation: `[` `]` and arrow movement in all tabs.
- Key actions: Enter/Left/Right/i/c/g/l/b/r/s/? across relevant tabs.
- Resize behavior: verify redraw and no line corruption.

### Discovery tests
- Normal network with `_wled._tcp` devices.
- Fallback path using `_http._tcp` + `/json/info` probe.
- Duplicate discovery entries and malformed lines (if simulation feasible).

### Offline/error tests
- Device unreachable during refresh (state failure -> offline/stale indicator).
- Effects/palettes/presets endpoint failures (ensure new error hints, no crash).
- Malformed JSON in state/info/effects (simulate via mocked files/spool where possible).

### Cache/state integrity tests
- Add/edit/delete device consistency in memory + persisted cache.
- Cache corruption or missing fields handling on startup.
- Verify terminal cleanup after Ctrl-C and normal quit.

### Lightweight scriptable checks
- `bash -n` on all shell files after each structural phase.
- Optional scripted key-sequence smoke (expecting no hang/crash) if a pseudo-tty harness is available.

## 11) Gaps / Unknowns

- Intent of `discover_devices` helper usage is unclear (appears unused by main flow); confirm before prioritizing fix.
- No explicit product decision documented for whether refresh modal should wait for all endpoint fetches or state only.
- No benchmark target documented for acceptable cache-write frequency under multi-device refresh.
- Limited observability for race windows in `events.queue` append path without stress tooling.

## Implemented in Pass 3 (Status Notes)
- Implemented shared discovery entry parsing helper (`parse_discovery_entry`) and migrated discovery consumers to use it.
- Fixed the confirmed `discover_devices` field mismatch (`name|host|addr|port` parsing).
- Implemented shared device-selection transition hook (`on_selected_device_changed` + `select_device_delta`) and migrated duplicated paths in `handle_key`/`handle_up`/`handle_down`.
- Normalized `model_add_device` power default to `false` to align with runtime boolean semantics.
