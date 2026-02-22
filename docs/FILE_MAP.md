# File Map

## Repository files

| Path | Purpose | Entry points | Depends on | Source-time side effects |
|---|---|---|---|---|
| `wledtui` | Main executable TUI, event loop, async network orchestration, key handlers | `main_loop`, `--smoke` mode | all `lib/*.sh`, curl/jq/tput/stty/etc. | Initializes many globals and keybinding tables. |
| `lib/util.sh` | Shared utilities: paths, logging, sanitization, locks, parse helpers, input reading | utility functions (`log_debug`, `with_lock`, etc.) | `jq`, `flock`, `tput`, `stty`, coreutils | Defines global config/cache paths. |
| `lib/model.sh` | Device state model and persistence | `model_add_device`, `model_load_devices`, `model_save_devices` | `lib/util.sh`, `jq` | Declares all `DEV_*` arrays and `DEVICE_IDS`. |
| `lib/api.sh` | WLED HTTP wrappers and probe logic | `api_get_*`, `api_set_state`, `api_probe_wled` | `curl`, `jq`, `lib/util.sh` | Defines timeout globals `API_CONNECT_TIMEOUT`, `API_MAX_TIME`. |
| `lib/discover.sh` | Avahi discovery + fallback probe flow | `discover_devices_report`, `discover_devices` | `avahi-browse`, `api_probe_wled`, model funcs | Sources util/api/model. |
| `lib/ui.sh` | UI style/format and terminal init/restore | `ui_init`, formatting functions | `tput`, `stty`, `lib/render.sh` | Sets EXIT/INT/TERM trap in `ui_init`. |
| `lib/render.sh` | Framebuffer-like incremental renderer | `render_draw_frame`, `render_flush_dirty` | terminal ANSI/tput | Switches to alt screen and hides cursor in `render_init`. |
| `scripts/dev_test_presets.sh` | Dev test script for `parse_presets_tsv` | `run_test` (script local) | `jq`, sourced util parse function | Exits non-zero on mismatch. |
| `README.md` | User-facing usage and feature summary | n/a | n/a | n/a |
| `LICENSE` | License text | n/a | n/a | n/a |

## Sourcing order
`wledtui` sources util -> model -> api -> discover -> ui (ui sources render).

## Notes
- Most modules assume globals defined by earlier-sourced files.
- Strong coupling exists via shared `DEV_*` associative arrays.
