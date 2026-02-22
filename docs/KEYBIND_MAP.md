# Keybinding Map

Links: [Function Index](./FUNCTION_INDEX.md), [Call Flows](./CALL_FLOWS.md).

## Key -> handler mapping

| Key | Context | Handler | Action | State changes | Network side effects |
|---|---|---|---|---|---|
| `q` | Global | `handle_key` | Quit | process exit | none |
| `?` | Global | `handle_key` | Toggle help overlay | `SHOW_HELP` | none |
| `Tab` | Global | `handle_key` | Next tab | `TAB_INDEX` | fetch presets/effects/palettes on entry |
| `Shift-Tab` (`ESC[Z`, `ESC[1;2Z`) | Global | `handle_key` | Previous tab | `TAB_INDEX` | same fetch behavior |
| `↑` (`ESC[A`) | Contextual | `handle_up` | Move selection | list indices | none |
| `↓` (`ESC[B`) | Contextual | `handle_down` | Move selection | list indices | none |
| `←` (`ESC[D`) | Tabs 0/2/4/5 | `handle_left` | Decrement brightness/effect param/RGB/transition | desired/UI fields, segment data | enqueue patch |
| `→` (`ESC[C`) | Tabs 0/2/4/5 | `handle_right` | Increment brightness/effect param/RGB/transition | desired/UI fields, segment data | enqueue patch |
| `Enter` | Contextual | `handle_enter` | Toggle/apply per-tab action | desired/UI fields | enqueue patch |
| `r` | Global | `begin_busy_refresh` | Refresh selected device | busy flags | schedule 5 async GETs |
| `s` | Global | `begin_busy_scan` | Scan devices | busy flags | discovery async subprocess |
| `a` | Devices | `handle_add_device` | Prompt add host:port | device model/cache | none immediate |
| `d` | Devices | `handle_delete_device` | Confirm delete | device model/cache | none |
| `e` | Devices | `handle_edit_device` | Prompt edit host:port | device model/cache | none |
| `[` / `]` | Devices | `handle_key` branches | Prev/next device | `SELECTED_DEVICE_INDEX` | tab-specific fetch maybe triggered |
| `l` | Global / advanced usage | `handle_live_toggle` | Toggle live mode | `DEV_DESIRED_LIVE` | enqueue `{live:...}` |
| `b` | Global | `handle_reboot` | Reboot (with confirm) | none local | enqueue `{rb:true}` |
| `i` | Effects tab | `handle_key` | Toggle speed/intensity adjust target | `EFFECT_PARAM` | none |
| `c` | Segments tab | `handle_key` | Cycle RGB channel | `COLOR_CHANNEL` | none |
| `g` | Segments tab | `handle_key` | Toggle apply-all | `SEG_APPLY_ALL` | affects later payload shape |

## Input parsing logic
- `read_key` reads one char non-blocking (`read -rsn1 -t 0.05`).
- If first char is ESC, it attempts to read continuation bytes for CSI/SS3 sequences.
- Returns `__NONE__` on timeout/no key.
- Enter accepted as empty string, `\n`, or `\r` in dispatch.

## Terminal compatibility notes
- Shift-Tab recognized only for `ESC[Z` and `ESC[1;2Z`.
- Escape-key alone (single ESC) is returned but not explicitly mapped (ignored).
- Behavior depends on terminal sending standard ANSI sequences.
