# Function Index

Source-of-truth behavior is in code. This index is best-effort and marks uncertainty as **Inference**.

## Inventory Table

| Function | File | Category | Signature | Calls | Called by | External commands | Summary |
|---|---|---|---|---|---|---|---|
| [sync_preset_index](#sync_preset_index) | `wledtui` | utility | `sync_preset_index()` | set_selected_preset_from_index | fetch_presets_locked |  | utility helper. |
| [set_selected_preset_from_index](#set_selected_preset_from_index) | `wledtui` | utility | `set_selected_preset_from_index()` |  | sync_preset_index, adjust_preset_index |  | utility helper. |
| [get_selected_preset_id](#get_selected_preset_id) | `wledtui` | utility | `get_selected_preset_id()` |  | handle_enter | printf | utility helper. |
| [adjust_preset_index](#adjust_preset_index) | `wledtui` | utility | `adjust_preset_index(delta)` | set_selected_preset_from_index | handle_up, handle_down |  | utility helper. |
| [fetch_presets](#fetch_presets) | `wledtui` | network | `fetch_presets(id)` | ensure_config_dir, api_get_presets, with_lock, fetch_presets_locked, schedule_presets_fetch | handle_key |  | network helper. |
| [fetch_presets_locked](#fetch_presets_locked) | `wledtui` | network | `fetch_presets_locked(id)` | preset_debug_log, parse_presets_tsv, sanitize_for_display, sync_preset_index | fetch_presets, process_get_result | mktemp, head, rm, printf | network helper. |
| [fetch_effects](#fetch_effects) | `wledtui` | network | `fetch_effects(id)` | load_effects_from_cache, schedule_effects_fetch | handle_key |  | network helper. |
| [fetch_palettes](#fetch_palettes) | `wledtui` | network | `fetch_palettes(id)` | load_palettes_from_cache, schedule_palettes_fetch | handle_key |  | network helper. |
| [load_effects_from_cache](#load_effects_from_cache) | `wledtui` | parsing | `load_effects_from_cache(id)` | parse_effects_tsv, sanitize_for_display, effects_debug_log | fetch_effects, process_get_result, smoke_test | jq, mktemp, head, rm | parsing helper. |
| [load_palettes_from_cache](#load_palettes_from_cache) | `wledtui` | parsing | `load_palettes_from_cache(id)` | sanitize_for_display, palettes_debug_log | fetch_palettes, process_get_result | jq, mktemp, head, rm | parsing helper. |
| [net_key](#net_key) | `wledtui` | network | `net_key(id)` |  | net_data_path, net_status_path, start_get_request, start_presets_request… | printf | network helper. |
| [ensure_net_spool_dir](#ensure_net_spool_dir) | `wledtui` | utility | `ensure_net_spool_dir()` | ensure_cache_dir | start_get_request, start_presets_request, start_patch_send, start_discover_scan |  | utility helper. |
| [net_events_path](#net_events_path) | `wledtui` | network | `net_events_path()` |  | start_get_request, start_presets_request, process_network_queue | printf | network helper. |
| [net_data_path](#net_data_path) | `wledtui` | network | `net_data_path(id, type)` | net_key | start_get_request, start_presets_request, process_get_result | printf | network helper. |
| [net_status_path](#net_status_path) | `wledtui` | network | `net_status_path(id, type)` | net_key | start_get_request, start_presets_request, process_get_result | printf | network helper. |
| [preset_debug_log](#preset_debug_log) | `wledtui` | utility | `preset_debug_log(id, message)` | device_display_name, log_debug | fetch_presets_locked, schedule_presets_fetch, process_get_result, build_presets_lines_locked |  | utility helper. |
| [effects_debug_log](#effects_debug_log) | `wledtui` | utility | `effects_debug_log(id, message)` | device_display_name, log_debug | load_effects_from_cache, process_get_result |  | utility helper. |
| [palettes_debug_log](#palettes_debug_log) | `wledtui` | utility | `palettes_debug_log(id, message)` | device_display_name, log_debug | load_palettes_from_cache, process_get_result |  | utility helper. |
| [start_get_request](#start_get_request) | `wledtui` | utility | `start_get_request(id, type, path)` | ensure_net_spool_dir, api_base_url, net_key, device_display_name, log_debug… | schedule_state_fetch, schedule_info_fetch, schedule_effects_fetch, schedule_palettes_fetch… | curl, tr, wc, head, mv, rm, printf | utility helper. |
| [start_presets_request](#start_presets_request) | `wledtui` | utility | `start_presets_request(id)` | ensure_net_spool_dir, api_base_url, net_key, device_display_name, net_data_path… | schedule_presets_fetch | curl, tr, wc, head, mv, rm, printf | utility helper. |
| [start_patch_send](#start_patch_send) | `wledtui` | utility | `start_patch_send(id, payload)` | ensure_net_spool_dir, api_base_url, sleep_ms | process_patch_queue | curl, printf | utility helper. |
| [device_display_brightness](#device_display_brightness) | `wledtui` | utility | `device_display_brightness(id)` |  | rebuild_device_cache, build_status_lines, handle_left, handle_right | printf | utility helper. |
| [device_display_on](#device_display_on) | `wledtui` | utility | `device_display_on(id)` |  | rebuild_device_cache, build_status_lines, handle_enter | printf | utility helper. |
| [device_display_preset](#device_display_preset) | `wledtui` | utility | `device_display_preset(id)` |  | rebuild_device_cache, build_status_lines | printf | utility helper. |
| [device_display_transition](#device_display_transition) | `wledtui` | utility | `device_display_transition(id)` |  | build_advanced_lines, handle_left, handle_right | printf | utility helper. |
| [device_display_nl_on](#device_display_nl_on) | `wledtui` | utility | `device_display_nl_on(id)` |  | build_advanced_lines, handle_enter | printf | utility helper. |
| [device_display_live](#device_display_live) | `wledtui` | utility | `device_display_live(id)` |  | build_advanced_lines, handle_live_toggle | printf | utility helper. |
| [brightness_pending_marker](#brightness_pending_marker) | `wledtui` | utility | `brightness_pending_marker(id)` |  | rebuild_device_cache, build_status_lines | printf | utility helper. |
| [desired_state_pending](#desired_state_pending) | `wledtui` | utility | `desired_state_pending(id)` |  | sync_desired_from_known |  | utility helper. |
| [sync_desired_from_known](#sync_desired_from_known) | `wledtui` | utility | `sync_desired_from_known(id)` | now_ms, desired_state_pending | apply_state_response, main_loop |  | utility helper. |
| [apply_state_response](#apply_state_response) | `wledtui` | utility | `apply_state_response(id)` | now_ts, sync_desired_from_known, current_device_id, now_ms, update_segment_texts… | process_get_result | jq | utility helper. |
| [apply_state_failure](#apply_state_failure) | `wledtui` | utility | `apply_state_failure(id)` | clamp, now_ts | process_get_result |  | utility helper. |
| [apply_info_response](#apply_info_response) | `wledtui` | utility | `apply_info_response(id)` | model_save_devices, now_ts | process_get_result | jq | utility helper. |
| [schedule_state_fetch](#schedule_state_fetch) | `wledtui` | async | `schedule_state_fetch(id)` | start_get_request | process_discover_results, begin_busy_refresh |  | async helper. |
| [schedule_info_fetch](#schedule_info_fetch) | `wledtui` | async | `schedule_info_fetch(id)` | start_get_request | process_discover_results, begin_busy_refresh |  | async helper. |
| [schedule_presets_fetch](#schedule_presets_fetch) | `wledtui` | async | `schedule_presets_fetch(id)` | preset_debug_log, start_presets_request | fetch_presets, process_discover_results, begin_busy_refresh |  | async helper. |
| [schedule_effects_fetch](#schedule_effects_fetch) | `wledtui` | async | `schedule_effects_fetch(id)` | start_get_request | fetch_effects, begin_busy_refresh |  | async helper. |
| [schedule_palettes_fetch](#schedule_palettes_fetch) | `wledtui` | async | `schedule_palettes_fetch(id)` | start_get_request | fetch_palettes, begin_busy_refresh |  | async helper. |
| [enqueue_patch](#enqueue_patch) | `wledtui` | utility | `enqueue_patch(id)` | now_ms | handle_left, handle_right, handle_enter, handle_live_toggle… | jq | utility helper. |
| [process_patch_queue](#process_patch_queue) | `wledtui` | async | `process_patch_queue()` | now_ms, start_patch_send | process_network_queue | kill, wait | async helper. |
| [process_get_result](#process_get_result) | `wledtui` | async | `process_get_result(id, type)` | net_status_path, net_data_path, apply_state_failure, apply_state_response, current_device_id… | process_network_queue | jq, awk, tr, wc, head, rm, printf, cat, kill, wait | async helper. |
| [process_network_queue](#process_network_queue) | `wledtui` | async | `process_network_queue()` | process_patch_queue, net_events_path, process_get_result | smoke_test_brightness_repeat, smoke_test, main_loop | mv, rm | async helper. |
| [start_discover_scan](#start_discover_scan) | `wledtui` | utility | `start_discover_scan()` | ensure_net_spool_dir, sleep_ms, discover_devices_report, now_ts | begin_busy_scan | mv, rm, printf, kill | utility helper. |
| [process_discover_results](#process_discover_results) | `wledtui` | async | `process_discover_results()` | now_ts, model_add_device, device_id, schedule_state_fetch, schedule_info_fetch… | main_loop | awk, rm, cat, kill, wait | async helper. |
| [apply_state_payload](#apply_state_payload) | `wledtui` | utility | `apply_state_payload(id, payload)` | api_set_state |  |  | utility helper. |
| [current_device_id](#current_device_id) | `wledtui` | utility | `current_device_id()` |  | apply_state_response, process_get_result, update_topbar_line, build_effects_lines… | printf | utility helper. |
| [box_top_line](#box_top_line) | `wledtui` | utility | `box_top_line(width)` | ui_trim_text | overlay_help, overlay_modal, build_frame | tr, printf | utility helper. |
| [box_bottom_line](#box_bottom_line) | `wledtui` | utility | `box_bottom_line(width)` |  | overlay_help, overlay_modal, build_frame | tr, printf | utility helper. |
| [blank_line](#blank_line) | `wledtui` | utility | `blank_line(width)` |  | update_list_selection, update_right_list_selection, build_frame | printf | utility helper. |
| [set_right_line](#set_right_line) | `wledtui` | utility | `set_right_line(width)` | ui_pad_text | build_status_lines, build_presets_lines_locked, build_effects_lines, build_palettes_lines… |  | utility helper. |
| [set_right_list_line](#set_right_list_line) | `wledtui` | utility | `set_right_list_line(width)` | ui_format_list_item | build_presets_lines_locked, build_effects_lines, build_palettes_lines, build_segments_lines |  | utility helper. |
| [update_segment_texts](#update_segment_texts) | `wledtui` | UI rendering | `update_segment_texts()` |  | apply_state_response, handle_key, handle_left, handle_right… | jq, tr | UI rendering helper. |
| [rebuild_device_cache](#rebuild_device_cache) | `wledtui` | UI rendering | `rebuild_device_cache()` | device_display_name, device_display_brightness, brightness_pending_marker, device_display_preset, device_display_on… | build_frame |  | UI rendering helper. |
| [rebuild_presets_cache](#rebuild_presets_cache) | `wledtui` | UI rendering | `rebuild_presets_cache()` | ui_format_list_item | build_frame | printf | UI rendering helper. |
| [rebuild_effects_cache](#rebuild_effects_cache) | `wledtui` | UI rendering | `rebuild_effects_cache()` | ui_format_list_item | build_frame | printf | UI rendering helper. |
| [rebuild_palettes_cache](#rebuild_palettes_cache) | `wledtui` | UI rendering | `rebuild_palettes_cache()` | ui_format_list_item | build_frame |  | UI rendering helper. |
| [rebuild_segments_cache](#rebuild_segments_cache) | `wledtui` | UI rendering | `rebuild_segments_cache()` | ui_format_list_item | build_frame |  | UI rendering helper. |
| [mark_dirty_row](#mark_dirty_row) | `wledtui` | utility | `mark_dirty_row()` | render_mark_dirty | update_topbar_line, update_inner_row |  | utility helper. |
| [binding_desc_for_key](#binding_desc_for_key) | `wledtui` | utility | `binding_desc_for_key(key)` |  | build_footer_hint | printf | utility helper. |
| [build_help_lines](#build_help_lines) | `wledtui` | UI rendering | `build_help_lines()` | format_key_label | build_frame | printf | UI rendering helper. |
| [format_key_label](#format_key_label) | `wledtui` | utility | `format_key_label(key)` |  | build_help_lines, build_footer_hint | printf | utility helper. |
| [current_tab_scope](#current_tab_scope) | `wledtui` | utility | `current_tab_scope()` |  | build_footer_hint | printf | utility helper. |
| [build_footer_hint](#build_footer_hint) | `wledtui` | UI rendering | `build_footer_hint()` | current_tab_scope, binding_desc_for_key, format_key_label | build_frame | printf | UI rendering helper. |
| [update_topbar_line](#update_topbar_line) | `wledtui` | UI rendering | `update_topbar_line(cols)` | current_device_id, device_display_name, ui_format_topbar, mark_dirty_row | handle_key, handle_up, handle_down |  | UI rendering helper. |
| [update_inner_row](#update_inner_row) | `wledtui` | UI rendering | `update_inner_row()` | mark_dirty_row | update_list_selection, update_right_list_selection, refresh_status_pane, refresh_advanced_pane… |  | UI rendering helper. |
| [update_list_selection](#update_list_selection) | `wledtui` | UI rendering | `update_list_selection()` | blank_line, update_inner_row | handle_key, handle_up, handle_down |  | UI rendering helper. |
| [update_right_list_selection](#update_right_list_selection) | `wledtui` | UI rendering | `update_right_list_selection()` | blank_line, update_inner_row | handle_up, handle_down |  | UI rendering helper. |
| [refresh_status_pane](#refresh_status_pane) | `wledtui` | utility | `refresh_status_pane(id)` | build_status_lines, update_inner_row | handle_key, handle_up, handle_down |  | utility helper. |
| [refresh_advanced_pane](#refresh_advanced_pane) | `wledtui` | utility | `refresh_advanced_pane(id)` | build_advanced_lines, update_inner_row | handle_key, handle_up, handle_down |  | utility helper. |
| [refresh_segments_info](#refresh_segments_info) | `wledtui` | utility | `refresh_segments_info()` | ui_pad_text, update_inner_row | handle_up, handle_down |  | utility helper. |
| [build_status_lines](#build_status_lines) | `wledtui` | UI rendering | `build_status_lines(id, width)` | device_display_name, device_display_on, device_display_brightness, brightness_pending_marker, device_display_preset… | refresh_status_pane, build_frame |  | UI rendering helper. |
| [build_presets_lines_locked](#build_presets_lines_locked) | `wledtui` | UI rendering | `build_presets_lines_locked(id, width)` | set_right_line, preset_debug_log, set_right_list_line | build_presets_lines | printf | UI rendering helper. |
| [build_presets_lines](#build_presets_lines) | `wledtui` | UI rendering | `build_presets_lines(id, width)` | with_lock, build_presets_lines_locked | build_frame |  | UI rendering helper. |
| [build_effects_lines](#build_effects_lines) | `wledtui` | UI rendering | `build_effects_lines(width)` | current_device_id, set_right_line, set_right_list_line |  | printf | UI rendering helper. |
| [build_palettes_lines](#build_palettes_lines) | `wledtui` | UI rendering | `build_palettes_lines(width)` | set_right_line, set_right_list_line |  |  | UI rendering helper. |
| [build_segments_lines](#build_segments_lines) | `wledtui` | UI rendering | `build_segments_lines(width)` | set_right_line, set_right_list_line |  |  | UI rendering helper. |
| [build_advanced_lines](#build_advanced_lines) | `wledtui` | UI rendering | `build_advanced_lines(id, width)` | set_right_line, device_display_transition, device_display_nl_on, device_display_live | refresh_advanced_pane, build_frame |  | UI rendering helper. |
| [spinner_frame](#spinner_frame) | `wledtui` | utility | `spinner_frame()` |  | current_modal_message | printf | utility helper. |
| [current_modal_message](#current_modal_message) | `wledtui` | utility | `current_modal_message()` | now_ms, spinner_frame | build_frame | printf | utility helper. |
| [set_modal_error](#set_modal_error) | `wledtui` | utility | `set_modal_error(message)` | now_ms | process_discover_results, update_busy_states |  | utility helper. |
| [begin_busy_scan](#begin_busy_scan) | `wledtui` | utility | `begin_busy_scan()` | now_ms, start_discover_scan | handle_key |  | utility helper. |
| [begin_busy_refresh](#begin_busy_refresh) | `wledtui` | utility | `begin_busy_refresh(id)` | log_debug, device_display_name, net_key, now_ms, schedule_state_fetch… | handle_key |  | utility helper. |
| [update_busy_states](#update_busy_states) | `wledtui` | UI rendering | `update_busy_states()` | now_ms, set_modal_error | main_loop |  | UI rendering helper. |
| [update_spinner](#update_spinner) | `wledtui` | UI rendering | `update_spinner()` | now_ms | main_loop |  | UI rendering helper. |
| [overlay_help](#overlay_help) | `wledtui` | UI rendering | `overlay_help(rows, cols)` | box_top_line, box_bottom_line, ui_pad_text | build_frame | printf | UI rendering helper. |
| [overlay_modal](#overlay_modal) | `wledtui` | UI rendering | `overlay_modal(rows, cols, message)` | ui_pad_text, box_top_line, box_bottom_line | build_frame | printf | UI rendering helper. |
| [build_frame](#build_frame) | `wledtui` | UI rendering | `build_frame(rows, cols)` | rebuild_device_cache, rebuild_presets_cache, rebuild_effects_cache, rebuild_palettes_cache, rebuild_segments_cache… | main_loop |  | UI rendering helper. |
| [handle_key](#handle_key) | `wledtui` | input handling | `handle_key(key)` | current_device_id, fetch_presets, fetch_effects, fetch_palettes, handle_up… | main_loop | jq | input handling helper. |
| [handle_up](#handle_up) | `wledtui` | input handling | `handle_up()` | adjust_preset_index, update_right_list_selection, refresh_segments_info, update_list_selection, update_topbar_line… | handle_key |  | input handling helper. |
| [handle_down](#handle_down) | `wledtui` | input handling | `handle_down()` | adjust_preset_index, update_right_list_selection, refresh_segments_info, update_list_selection, update_topbar_line… | handle_key |  | input handling helper. |
| [handle_left](#handle_left) | `wledtui` | input handling | `handle_left()` | current_device_id, device_display_brightness, clamp, enqueue_patch, device_display_transition… | handle_key | jq | input handling helper. |
| [handle_right](#handle_right) | `wledtui` | input handling | `handle_right()` | current_device_id, device_display_brightness, clamp, enqueue_patch, device_display_transition… | handle_key | jq | input handling helper. |
| [handle_enter](#handle_enter) | `wledtui` | input handling | `handle_enter(id)` | device_display_on, enqueue_patch, with_lock, get_selected_preset_id, update_segment_texts… | handle_key | jq | input handling helper. |
| [handle_add_device](#handle_add_device) | `wledtui` | input handling | `handle_add_device()` | ui_clear, prompt_input, model_add_device, model_save_devices | handle_key | tput | input handling helper. |
| [handle_delete_device](#handle_delete_device) | `wledtui` | input handling | `handle_delete_device()` | current_device_id, confirm_prompt, device_display_name, model_remove_device, model_save_devices | handle_key |  | input handling helper. |
| [handle_edit_device](#handle_edit_device) | `wledtui` | input handling | `handle_edit_device()` | current_device_id, ui_clear, prompt_input, device_display_name, is_valid_host… | handle_key | tput | input handling helper. |
| [handle_live_toggle](#handle_live_toggle) | `wledtui` | input handling | `handle_live_toggle(id)` | device_display_live, enqueue_patch | handle_key | jq | input handling helper. |
| [handle_reboot](#handle_reboot) | `wledtui` | input handling | `handle_reboot(id)` | confirm_prompt, device_display_name, enqueue_patch | handle_key | jq | input handling helper. |
| [smoke_test_brightness_repeat](#smoke_test_brightness_repeat) | `wledtui` | testing | `smoke_test_brightness_repeat(id)` | now_ms, enqueue_patch, process_network_queue, sleep_ms | smoke_test | jq, printf | testing helper. |
| [smoke_test](#smoke_test) | `wledtui` | testing | `smoke_test(target)` | model_add_device, device_id, api_get_info, api_set_state, api_get_state… |  | jq, awk, head, printf | testing helper. |
| [main_loop](#main_loop) | `wledtui` | startup | `main_loop()` | model_load_devices, sync_desired_from_known, current_device_id, update_segment_texts, ui_init… |  | jq | startup helper. |
| [api_base_url](#api_base_url) | `lib/api.sh` | WLED API | `api_base_url(id)` |  | start_get_request, start_presets_request, start_patch_send, api_request | printf | WLED API helper. |
| [api_request](#api_request) | `lib/api.sh` | WLED API | `api_request(method, id, path, payload)` | api_base_url, device_display_name, log_debug | api_get_info, api_get_state, api_set_state, api_get_effects… | curl, printf | WLED API helper. |
| [api_get_info](#api_get_info) | `lib/api.sh` | WLED API | `api_get_info(id)` | api_request | smoke_test |  | WLED API helper. |
| [api_get_state](#api_get_state) | `lib/api.sh` | WLED API | `api_get_state(id)` | api_request | smoke_test |  | WLED API helper. |
| [api_set_state](#api_set_state) | `lib/api.sh` | WLED API | `api_set_state(id, payload)` | api_request | apply_state_payload, smoke_test |  | WLED API helper. |
| [api_get_effects](#api_get_effects) | `lib/api.sh` | WLED API | `api_get_effects(id)` | api_request |  |  | WLED API helper. |
| [api_get_palettes](#api_get_palettes) | `lib/api.sh` | WLED API | `api_get_palettes(id)` | api_request |  |  | WLED API helper. |
| [api_get_presets](#api_get_presets) | `lib/api.sh` | WLED API | `api_get_presets(id)` | api_request | fetch_presets, smoke_test | printf | WLED API helper. |
| [api_probe_wled](#api_probe_wled) | `lib/api.sh` | WLED API | `api_probe_wled(host, port)` | is_valid_host, is_valid_port | discover_devices_report | curl, jq, printf | WLED API helper. |
| [discover_parse_avahi](#discover_parse_avahi) | `lib/discover.sh` | discovery | `discover_parse_avahi(service)` |  | discover_primary, discover_secondary | avahi-browse, printf | discovery helper. |
| [discover_primary](#discover_primary) | `lib/discover.sh` | discovery | `discover_primary()` | is_command, discover_parse_avahi | discover_devices_report | avahi-browse | discovery helper. |
| [discover_secondary](#discover_secondary) | `lib/discover.sh` | discovery | `discover_secondary()` | is_command, discover_parse_avahi | discover_devices_report | avahi-browse | discovery helper. |
| [discover_devices_report](#discover_devices_report) | `lib/discover.sh` | discovery | `discover_devices_report()` | discover_primary, api_probe_wled, discover_secondary | start_discover_scan, discover_devices | printf | discovery helper. |
| [discover_devices](#discover_devices) | `lib/discover.sh` | discovery | `discover_devices()` | now_ts, model_add_device, device_id, discover_devices_report |  |  | discovery helper. |
| [device_id](#device_id) | `lib/model.sh` | utility | `device_id(host, port)` |  | process_discover_results, handle_edit_device, smoke_test, discover_devices… | printf | utility helper. |
| [model_add_device](#model_add_device) | `lib/model.sh` | device mgmt | `model_add_device(name, host, port)` | is_valid_host, is_valid_port, log_debug, device_id | process_discover_results, handle_add_device, handle_edit_device, smoke_test… |  | device mgmt helper. |
| [model_remove_device](#model_remove_device) | `lib/model.sh` | device mgmt | `model_remove_device(id)` |  | handle_delete_device, handle_edit_device |  | device mgmt helper. |
| [device_display_name](#device_display_name) | `lib/model.sh` | utility | `device_display_name(id)` |  | preset_debug_log, effects_debug_log, palettes_debug_log, start_get_request… | printf | utility helper. |
| [model_load_devices](#model_load_devices) | `lib/model.sh` | device mgmt | `model_load_devices()` | ensure_cache_dir, is_valid_host, is_valid_port, log_debug, device_id… | main_loop | jq, printf | device mgmt helper. |
| [model_save_devices](#model_save_devices) | `lib/model.sh` | device mgmt | `model_save_devices()` | ensure_cache_dir, with_lock, write_file | apply_state_response, apply_info_response, process_discover_results, handle_add_device… | jq | device mgmt helper. |
| [render_init](#render_init) | `lib/render.sh` | UI rendering | `render_init()` | render_set_size | ui_init | printf | UI rendering helper. |
| [render_set_size](#render_set_size) | `lib/render.sh` | UI rendering | `render_set_size()` |  | main_loop, render_init | tput | UI rendering helper. |
| [render_cup](#render_cup) | `lib/render.sh` | UI rendering | `render_cup()` |  | render_draw_frame, render_flush_dirty | printf | UI rendering helper. |
| [render_mark_dirty](#render_mark_dirty) | `lib/render.sh` | UI rendering | `render_mark_dirty()` |  | mark_dirty_row |  | UI rendering helper. |
| [render_has_dirty](#render_has_dirty) | `lib/render.sh` | UI rendering | `render_has_dirty()` |  | main_loop |  | UI rendering helper. |
| [render_clear_dirty](#render_clear_dirty) | `lib/render.sh` | UI rendering | `render_clear_dirty()` |  | render_draw_frame, render_flush_dirty |  | UI rendering helper. |
| [render_draw_frame](#render_draw_frame) | `lib/render.sh` | UI rendering | `render_draw_frame()` | render_cup, render_clear_dirty | main_loop, render_flush_dirty | printf | UI rendering helper. |
| [render_flush_dirty](#render_flush_dirty) | `lib/render.sh` | UI rendering | `render_flush_dirty()` | render_draw_frame, render_cup, render_clear_dirty | main_loop | printf | UI rendering helper. |
| [render_shutdown](#render_shutdown) | `lib/render.sh` | teardown | `render_shutdown()` |  | ui_restore | printf | teardown helper. |
| [ui_init](#ui_init) | `lib/ui.sh` | UI rendering | `ui_init()` | color_support, render_init, ui_restore | main_loop | tput, stty | UI rendering helper. |
| [ui_restore](#ui_restore) | `lib/ui.sh` | teardown | `ui_restore()` | render_shutdown | ui_init | stty | teardown helper. |
| [ui_clear](#ui_clear) | `lib/ui.sh` | UI rendering | `ui_clear()` |  | handle_add_device, handle_edit_device | tput | UI rendering helper. |
| [ui_trim_text](#ui_trim_text) | `lib/ui.sh` | UI rendering | `ui_trim_text(width)` | sanitize_for_display | box_top_line, ui_pad_text, ui_format_topbar, ui_format_footer… | printf | UI rendering helper. |
| [ui_pad_text](#ui_pad_text) | `lib/ui.sh` | UI rendering | `ui_pad_text(width)` | ui_trim_text | set_right_line, refresh_segments_info, overlay_help, overlay_modal… | printf | UI rendering helper. |
| [ui_format_topbar](#ui_format_topbar) | `lib/ui.sh` | UI rendering | `ui_format_topbar(cols)` | ui_trim_text | update_topbar_line, build_frame | printf | UI rendering helper. |
| [ui_format_footer](#ui_format_footer) | `lib/ui.sh` | UI rendering | `ui_format_footer(cols)` | ui_trim_text | build_frame | printf | UI rendering helper. |
| [ui_format_list_item](#ui_format_list_item) | `lib/ui.sh` | UI rendering | `ui_format_list_item(width)` | ui_trim_text | set_right_list_line, rebuild_device_cache, rebuild_presets_cache, rebuild_effects_cache… | printf | UI rendering helper. |
| [log_debug](#log_debug) | `lib/util.sh` | utility | `log_debug()` | ensure_cache_dir | preset_debug_log, effects_debug_log, palettes_debug_log, start_get_request… | date, printf | utility helper. |
| [strip_ansi](#strip_ansi) | `lib/util.sh` | utility | `strip_ansi()` |  | sanitize_for_display | sed, printf | utility helper. |
| [sanitize_for_display](#sanitize_for_display) | `lib/util.sh` | utility | `sanitize_for_display()` | strip_ansi | fetch_presets_locked, load_effects_from_cache, load_palettes_from_cache, start_get_request… | tr, printf | utility helper. |
| [is_valid_host](#is_valid_host) | `lib/util.sh` | utility | `is_valid_host(host)` |  | handle_edit_device, api_probe_wled, model_add_device, model_load_devices |  | utility helper. |
| [is_valid_port](#is_valid_port) | `lib/util.sh` | utility | `is_valid_port(port)` |  | handle_edit_device, api_probe_wled, model_add_device, model_load_devices |  | utility helper. |
| [write_file](#write_file) | `lib/util.sh` | utility | `write_file(path)` |  | model_save_devices | printf | utility helper. |
| [now_ts](#now_ts) | `lib/util.sh` | utility | `now_ts()` |  | start_get_request, start_presets_request, apply_state_response, apply_state_failure… | date | utility helper. |
| [now_ms](#now_ms) | `lib/util.sh` | utility | `now_ms()` |  | sync_desired_from_known, apply_state_response, enqueue_patch, process_patch_queue… | date | utility helper. |
| [sleep_ms](#sleep_ms) | `lib/util.sh` | utility | `sleep_ms()` |  | start_get_request, start_presets_request, start_patch_send, start_discover_scan… | awk, sleep, printf | utility helper. |
| [ensure_config_dir](#ensure_config_dir) | `lib/util.sh` | utility | `ensure_config_dir()` |  | fetch_presets |  | utility helper. |
| [ensure_cache_dir](#ensure_cache_dir) | `lib/util.sh` | utility | `ensure_cache_dir()` |  | ensure_net_spool_dir, model_load_devices, model_save_devices, log_debug |  | utility helper. |
| [clamp](#clamp) | `lib/util.sh` | utility | `clamp()` |  | apply_state_failure, handle_left, handle_right | printf | utility helper. |
| [json_safe](#json_safe) | `lib/util.sh` | utility | `json_safe()` |  |  | jq | utility helper. |
| [is_command](#is_command) | `lib/util.sh` | utility | `is_command()` |  | discover_primary, discover_secondary | command | utility helper. |
| [color_support](#color_support) | `lib/util.sh` | utility | `color_support()` |  | ui_init | tput | utility helper. |
| [set_term_title](#set_term_title) | `lib/util.sh` | utility | `set_term_title()` | sanitize_for_display | main_loop | printf | utility helper. |
| [with_lock](#with_lock) | `lib/util.sh` | utility | `with_lock()` |  | fetch_presets, process_get_result, build_presets_lines, handle_enter… | flock | utility helper. |
| [parse_presets_tsv](#parse_presets_tsv) | `lib/util.sh` | utility | `parse_presets_tsv()` |  | fetch_presets_locked, smoke_test, run_test | jq | utility helper. |
| [parse_effects_tsv](#parse_effects_tsv) | `lib/util.sh` | utility | `parse_effects_tsv()` |  | load_effects_from_cache | jq | utility helper. |
| [read_key](#read_key) | `lib/util.sh` | utility | `read_key()` |  | main_loop | printf | utility helper. |
| [prompt_input](#prompt_input) | `lib/util.sh` | utility | `prompt_input(prompt)` | sanitize_for_display | handle_add_device, handle_edit_device | tput, stty, printf | utility helper. |
| [confirm_prompt](#confirm_prompt) | `lib/util.sh` | utility | `confirm_prompt(prompt)` | sanitize_for_display | handle_delete_device, handle_reboot | tput, stty, printf | utility helper. |
| [run_test](#run_test) | `scripts/dev_test_presets.sh` | utility | `run_test(name)` | parse_presets_tsv |  | printf | utility helper. |

## Function Details

### sync_preset_index
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** sync_preset_index() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** PRESETS_IDS, PRESET_INDEX
- **External commands:** None detected.
- **Calls:** set_selected_preset_from_index.
- **Called by:** fetch_presets_locked.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### set_selected_preset_from_index
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** set_selected_preset_from_index() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** PRESETS_IDS, PRESET_INDEX, SELECTED_PRESET_ID
- **External commands:** None detected.
- **Calls:** None detected.
- **Called by:** sync_preset_index, adjust_preset_index.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### get_selected_preset_id
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** get_selected_preset_id() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** PRESETS_IDS, PRESET_INDEX
- **External commands:** printf.
- **Calls:** None detected.
- **Called by:** handle_enter.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### adjust_preset_index
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** adjust_preset_index(delta) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** PRESETS_IDS, PRESET_INDEX, SELECTED_PRESET_ID
- **External commands:** None detected.
- **Calls:** set_selected_preset_from_index.
- **Called by:** handle_up, handle_down.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### fetch_presets
- **File:** `wledtui`
- **Purpose:** network operation.
- **Parameters:** fetch_presets(id) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEV_PRESETS_JSON, PRESETS_LOCK
- **External commands:** None detected.
- **Calls:** ensure_config_dir, api_get_presets, with_lock, fetch_presets_locked, schedule_presets_fetch.
- **Called by:** handle_key.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### fetch_presets_locked
- **File:** `wledtui`
- **Purpose:** network operation.
- **Parameters:** fetch_presets_locked(id) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEV_DESIRED_PRESET, DEV_PRESET, DEV_PRESETS_JSON, IFS, PRESETS_CACHE_DIRTY, PRESETS_IDS, PRESETS_NAMES, PRESET_INDEX, SELECTED_PRESET_ID
- **External commands:** mktemp, head, rm, printf.
- **Calls:** preset_debug_log, parse_presets_tsv, sanitize_for_display, sync_preset_index.
- **Called by:** fetch_presets, process_get_result.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### fetch_effects
- **File:** `wledtui`
- **Purpose:** network operation.
- **Parameters:** fetch_effects(id) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** 
- **External commands:** None detected.
- **Calls:** load_effects_from_cache, schedule_effects_fetch.
- **Called by:** handle_key.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### fetch_palettes
- **File:** `wledtui`
- **Purpose:** network operation.
- **Parameters:** fetch_palettes(id) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** 
- **External commands:** None detected.
- **Calls:** load_palettes_from_cache, schedule_palettes_fetch.
- **Called by:** handle_key.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### load_effects_from_cache
- **File:** `wledtui`
- **Purpose:** parsing operation.
- **Parameters:** load_effects_from_cache(id) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEV_EFFECTS_JSON, DEV_EFFECTS_PARSE_ERROR, EFFECTS, EFFECTS_CACHE_DIRTY, EFFECT_IDS, EFFECT_INDEX, IFS
- **External commands:** jq, mktemp, head, rm.
- **Calls:** parse_effects_tsv, sanitize_for_display, effects_debug_log.
- **Called by:** fetch_effects, process_get_result, smoke_test.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### load_palettes_from_cache
- **File:** `wledtui`
- **Purpose:** parsing operation.
- **Parameters:** load_palettes_from_cache(id) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEV_PALETTES_JSON, PALETTES, PALETTES_CACHE_DIRTY
- **External commands:** jq, mktemp, head, rm.
- **Calls:** sanitize_for_display, palettes_debug_log.
- **Called by:** fetch_palettes, process_get_result.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### net_key
- **File:** `wledtui`
- **Purpose:** network operation.
- **Parameters:** net_key(id) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** 
- **External commands:** printf.
- **Calls:** None detected.
- **Called by:** net_data_path, net_status_path, start_get_request, start_presets_request, begin_busy_refresh.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### ensure_net_spool_dir
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** ensure_net_spool_dir() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** CACHE_DIR
- **External commands:** None detected.
- **Calls:** ensure_cache_dir.
- **Called by:** start_get_request, start_presets_request, start_patch_send, start_discover_scan.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### net_events_path
- **File:** `wledtui`
- **Purpose:** network operation.
- **Parameters:** net_events_path() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** CACHE_DIR
- **External commands:** printf.
- **Calls:** None detected.
- **Called by:** start_get_request, start_presets_request, process_network_queue.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### net_data_path
- **File:** `wledtui`
- **Purpose:** network operation.
- **Parameters:** net_data_path(id, type) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** CACHE_DIR
- **External commands:** printf.
- **Calls:** net_key.
- **Called by:** start_get_request, start_presets_request, process_get_result.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### net_status_path
- **File:** `wledtui`
- **Purpose:** network operation.
- **Parameters:** net_status_path(id, type) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** CACHE_DIR
- **External commands:** printf.
- **Calls:** net_key.
- **Called by:** start_get_request, start_presets_request, process_get_result.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### preset_debug_log
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** preset_debug_log(id, message) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEBUG_PRESETS_REMOVE, DEV_PRESETS_CYCLE
- **External commands:** None detected.
- **Calls:** device_display_name, log_debug.
- **Called by:** fetch_presets_locked, schedule_presets_fetch, process_get_result, build_presets_lines_locked.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### effects_debug_log
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** effects_debug_log(id, message) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** 
- **External commands:** None detected.
- **Calls:** device_display_name, log_debug.
- **Called by:** load_effects_from_cache, process_get_result.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### palettes_debug_log
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** palettes_debug_log(id, message) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** 
- **External commands:** None detected.
- **Calls:** device_display_name, log_debug.
- **Called by:** load_palettes_from_cache, process_get_result.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### start_get_request
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** start_get_request(id, type, path) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** API_CONNECT_TIMEOUT, API_MAX_TIME, URL, WLEDTUI_NET_DELAY_MS
- **External commands:** curl, tr, wc, head, mv, rm, printf.
- **Calls:** ensure_net_spool_dir, api_base_url, net_key, device_display_name, log_debug, sanitize_for_display, net_data_path, net_status_path, net_events_path, sleep_ms, now_ts.
- **Called by:** schedule_state_fetch, schedule_info_fetch, schedule_effects_fetch, schedule_palettes_fetch, smoke_test.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### start_presets_request
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** start_presets_request(id) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** API_CONNECT_TIMEOUT, API_MAX_TIME, URL, WLEDTUI_NET_DELAY_MS
- **External commands:** curl, tr, wc, head, mv, rm, printf.
- **Calls:** ensure_net_spool_dir, api_base_url, net_key, device_display_name, net_data_path, net_status_path, net_events_path, log_debug, sanitize_for_display, sleep_ms, now_ts.
- **Called by:** schedule_presets_fetch.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### start_patch_send
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** start_patch_send(id, payload) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** API_CONNECT_TIMEOUT, API_MAX_TIME, H, POST, URL, WLEDTUI_ASYNC_DRY_RUN, WLEDTUI_NET_DELAY_MS, X
- **External commands:** curl, printf.
- **Calls:** ensure_net_spool_dir, api_base_url, sleep_ms.
- **Called by:** process_patch_queue.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### device_display_brightness
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** device_display_brightness(id) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEV_BRI, DEV_UI_BRI
- **External commands:** printf.
- **Calls:** None detected.
- **Called by:** rebuild_device_cache, build_status_lines, handle_left, handle_right.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### device_display_on
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** device_display_on(id) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEV_DESIRED_ON, DEV_ON
- **External commands:** printf.
- **Calls:** None detected.
- **Called by:** rebuild_device_cache, build_status_lines, handle_enter.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### device_display_preset
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** device_display_preset(id) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEV_DESIRED_PRESET, DEV_PRESET
- **External commands:** printf.
- **Calls:** None detected.
- **Called by:** rebuild_device_cache, build_status_lines.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### device_display_transition
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** device_display_transition(id) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEV_DESIRED_TRANSITION, DEV_TRANSITION
- **External commands:** printf.
- **Calls:** None detected.
- **Called by:** build_advanced_lines, handle_left, handle_right.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### device_display_nl_on
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** device_display_nl_on(id) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEV_DESIRED_NL_ON, DEV_NL_ON
- **External commands:** printf.
- **Calls:** None detected.
- **Called by:** build_advanced_lines, handle_enter.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### device_display_live
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** device_display_live(id) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEV_DESIRED_LIVE, DEV_LIVE
- **External commands:** printf.
- **Calls:** None detected.
- **Called by:** build_advanced_lines, handle_live_toggle.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### brightness_pending_marker
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** brightness_pending_marker(id) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEV_BRI, DEV_UI_BRI
- **External commands:** printf.
- **Calls:** None detected.
- **Called by:** rebuild_device_cache, build_status_lines.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### desired_state_pending
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** desired_state_pending(id) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEV_BRI, DEV_DESIRED_BRI, DEV_DESIRED_LIVE, DEV_DESIRED_NL_ON, DEV_DESIRED_ON, DEV_DESIRED_PRESET, DEV_DESIRED_TRANSITION, DEV_LIVE, DEV_NL_ON, DEV_ON, DEV_PRESET, DEV_TRANSITION
- **External commands:** None detected.
- **Calls:** None detected.
- **Called by:** sync_desired_from_known.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### sync_desired_from_known
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** sync_desired_from_known(id) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEVICE_LIST_DIRTY, DEV_BRI, DEV_DESIRED_BRI, DEV_DESIRED_LIVE, DEV_DESIRED_NL_ON, DEV_DESIRED_ON, DEV_DESIRED_PRESET, DEV_DESIRED_TRANSITION, DEV_LAST_USER_ACTION_MS, DEV_LIVE, DEV_NL_ON, DEV_ON, DEV_ONLINE, DEV_PATCH_INFLIGHT_PID, DEV_PENDING_PATCH, DEV_PRESET, DEV_TRANSITION, DEV_UI_BRI…
- **External commands:** None detected.
- **Calls:** now_ms, desired_state_pending.
- **Called by:** apply_state_response, main_loop.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### apply_state_response
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** apply_state_response(id) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEVICE_LIST_DIRTY, DEV_BACKOFF, DEV_BRI, DEV_LAST_USER_ACTION_MS, DEV_LIVE, DEV_NEXT_POLL, DEV_NL_DUR, DEV_NL_ON, DEV_ON, DEV_ONLINE, DEV_PRESET, DEV_STATE_JSON, DEV_STATE_STALE, DEV_STATE_TS, DEV_TRANSITION, MODEL_DIRTY, SEGMENTS, UI_ACTIVE_WINDOW_MS
- **External commands:** jq.
- **Calls:** now_ts, sync_desired_from_known, current_device_id, now_ms, update_segment_texts, model_save_devices.
- **Called by:** process_get_result.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### apply_state_failure
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** apply_state_failure(id) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEVICE_LIST_DIRTY, DEV_BACKOFF, DEV_NEXT_POLL, DEV_ONLINE, DEV_STATE_JSON, DEV_STATE_STALE, MODEL_DIRTY
- **External commands:** None detected.
- **Calls:** clamp, now_ts.
- **Called by:** process_get_result.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### apply_info_response
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** apply_info_response(id) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEV_INFO_JSON, DEV_INFO_TS, DEV_UPTIME, DEV_VER, DEV_WIFI, DEV_WLED_NAME, MODEL_DIRTY
- **External commands:** jq.
- **Calls:** model_save_devices, now_ts.
- **Called by:** process_get_result.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### schedule_state_fetch
- **File:** `wledtui`
- **Purpose:** async operation.
- **Parameters:** schedule_state_fetch(id) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEV_GET_STATE_INFLIGHT_PID
- **External commands:** None detected.
- **Calls:** start_get_request.
- **Called by:** process_discover_results, begin_busy_refresh.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### schedule_info_fetch
- **File:** `wledtui`
- **Purpose:** async operation.
- **Parameters:** schedule_info_fetch(id) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEV_GET_INFO_INFLIGHT_PID
- **External commands:** None detected.
- **Calls:** start_get_request.
- **Called by:** process_discover_results, begin_busy_refresh.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### schedule_presets_fetch
- **File:** `wledtui`
- **Purpose:** async operation.
- **Parameters:** schedule_presets_fetch(id) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEV_GET_PRESETS_INFLIGHT_PID, DEV_PRESETS_CYCLE, PRESETS_REFRESH_SEQ
- **External commands:** None detected.
- **Calls:** preset_debug_log, start_presets_request.
- **Called by:** fetch_presets, process_discover_results, begin_busy_refresh.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### schedule_effects_fetch
- **File:** `wledtui`
- **Purpose:** async operation.
- **Parameters:** schedule_effects_fetch(id) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEV_GET_EFFECTS_INFLIGHT_PID
- **External commands:** None detected.
- **Calls:** start_get_request.
- **Called by:** fetch_effects, begin_busy_refresh.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### schedule_palettes_fetch
- **File:** `wledtui`
- **Purpose:** async operation.
- **Parameters:** schedule_palettes_fetch(id) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEV_GET_PALETTES_INFLIGHT_PID
- **External commands:** None detected.
- **Calls:** start_get_request.
- **Called by:** fetch_palettes, begin_busy_refresh.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### enqueue_patch
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** enqueue_patch(id) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEV_LAST_USER_ACTION_MS, DEV_PATCH_DUE_MS, DEV_PENDING_PATCH, PATCH_DEBOUNCE_MS
- **External commands:** jq.
- **Calls:** now_ms.
- **Called by:** handle_left, handle_right, handle_enter, handle_live_toggle, handle_reboot, smoke_test_brightness_repeat.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### process_patch_queue
- **File:** `wledtui`
- **Purpose:** async operation.
- **Parameters:** process_patch_queue() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEVICE_IDS, DEVICE_LIST_DIRTY, DEV_BACKOFF, DEV_ONLINE, DEV_PATCH_DUE_MS, DEV_PATCH_INFLIGHT_PID, DEV_PATCH_LAST_SEND_MS, DEV_PENDING_PATCH, PATCH_MIN_SEND_INTERVAL_MS, UI_DIRTY
- **External commands:** kill, wait.
- **Calls:** now_ms, start_patch_send.
- **Called by:** process_network_queue.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### process_get_result
- **File:** `wledtui`
- **Purpose:** async operation.
- **Parameters:** process_get_result(id, type) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEV_EFFECTS_JSON, DEV_EFFECTS_TS, DEV_GET_EFFECTS_INFLIGHT_PID, DEV_GET_INFO_INFLIGHT_PID, DEV_GET_PALETTES_INFLIGHT_PID, DEV_GET_PRESETS_INFLIGHT_PID, DEV_GET_STATE_INFLIGHT_PID, DEV_PALETTES_JSON, DEV_PRESETS_JSON, LAST_REFRESH_SELECTED, PRESETS_LOCK, TAB_INDEX, UI_BUSY_REFRESH, UI_BUSY_REFRESH_ERROR, UI_BUSY_REFRESH_ID, UI_DIRTY
- **External commands:** jq, awk, tr, wc, head, rm, printf, cat, kill, wait.
- **Calls:** net_status_path, net_data_path, apply_state_failure, apply_state_response, current_device_id, now_ts, apply_info_response, sanitize_for_display, preset_debug_log, with_lock, fetch_presets_locked, effects_debug_log, load_effects_from_cache, palettes_debug_log, load_palettes_from_cache.
- **Called by:** process_network_queue.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### process_network_queue
- **File:** `wledtui`
- **Purpose:** async operation.
- **Parameters:** process_network_queue() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** IFS
- **External commands:** mv, rm.
- **Calls:** process_patch_queue, net_events_path, process_get_result.
- **Called by:** smoke_test_brightness_repeat, smoke_test, main_loop.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### start_discover_scan
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** start_discover_scan() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** CACHE_DIR, DISCOVER_INFLIGHT_PID, DISCOVER_REQUESTED, WLEDTUI_NET_DELAY_MS
- **External commands:** mv, rm, printf, kill.
- **Calls:** ensure_net_spool_dir, sleep_ms, discover_devices_report, now_ts.
- **Called by:** begin_busy_scan.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### process_discover_results
- **File:** `wledtui`
- **Purpose:** async operation.
- **Parameters:** process_discover_results() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** CACHE_DIR, DEVICE_LIST_DIRTY, DEV_LAST_SEEN, DISCOVER_INFLIGHT_PID, DISCOVER_REQUESTED, IFS, UI_BUSY_SCAN, UI_DIRTY
- **External commands:** awk, rm, cat, kill, wait.
- **Calls:** now_ts, model_add_device, device_id, schedule_state_fetch, schedule_info_fetch, schedule_presets_fetch, model_save_devices, set_modal_error.
- **Called by:** main_loop.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### apply_state_payload
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** apply_state_payload(id, payload) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** MODEL_BUSY, UI_DIRTY
- **External commands:** None detected.
- **Calls:** api_set_state.
- **Called by:** Entry/internal only.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### current_device_id
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** current_device_id() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEVICE_IDS, SELECTED_DEVICE_INDEX
- **External commands:** printf.
- **Calls:** None detected.
- **Called by:** apply_state_response, process_get_result, update_topbar_line, build_effects_lines, build_frame, handle_key, handle_up, handle_down, handle_left, handle_right, handle_delete_device, handle_edit_device, main_loop.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### box_top_line
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** box_top_line(width) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** 
- **External commands:** tr, printf.
- **Calls:** ui_trim_text.
- **Called by:** overlay_help, overlay_modal, build_frame.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### box_bottom_line
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** box_bottom_line(width) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** 
- **External commands:** tr, printf.
- **Calls:** None detected.
- **Called by:** overlay_help, overlay_modal, build_frame.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### blank_line
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** blank_line(width) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** 
- **External commands:** printf.
- **Calls:** None detected.
- **Called by:** update_list_selection, update_right_list_selection, build_frame.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### set_right_line
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** set_right_line(width) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** FRAME_INNER_ROWS, RIGHT_LINES
- **External commands:** None detected.
- **Calls:** ui_pad_text.
- **Called by:** build_status_lines, build_presets_lines_locked, build_effects_lines, build_palettes_lines, build_segments_lines, build_advanced_lines.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### set_right_list_line
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** set_right_list_line(width) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** FRAME_INNER_ROWS, RIGHT_LINES
- **External commands:** None detected.
- **Calls:** ui_format_list_item.
- **Called by:** build_presets_lines_locked, build_effects_lines, build_palettes_lines, build_segments_lines.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### update_segment_texts
- **File:** `wledtui`
- **Purpose:** UI rendering operation.
- **Parameters:** update_segment_texts() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** SEGMENTS, SEGMENTS_CACHE_DIRTY, SEGMENT_PRIMARY_COLOR, SEGMENT_TEXT
- **External commands:** jq, tr.
- **Calls:** None detected.
- **Called by:** apply_state_response, handle_key, handle_left, handle_right, handle_enter, main_loop.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### rebuild_device_cache
- **File:** `wledtui`
- **Purpose:** UI rendering operation.
- **Parameters:** rebuild_device_cache() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEVICE_IDS, DEVICE_LIST_DIRTY, DEV_ONLINE, DEV_STATE_STALE, LEFT_CACHE_WIDTH, LEFT_INNER_WIDTH, LEFT_ROW_NORMAL, LEFT_ROW_SELECTED
- **External commands:** None detected.
- **Calls:** device_display_name, device_display_brightness, brightness_pending_marker, device_display_preset, device_display_on, ui_format_list_item.
- **Called by:** build_frame.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### rebuild_presets_cache
- **File:** `wledtui`
- **Purpose:** UI rendering operation.
- **Parameters:** rebuild_presets_cache() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** PRESETS_CACHE_DIRTY, PRESETS_IDS, PRESETS_NAMES, PRESETS_ROW_NORMAL, PRESETS_ROW_SELECTED, RIGHT_CACHE_WIDTH, RIGHT_INNER_WIDTH
- **External commands:** printf.
- **Calls:** ui_format_list_item.
- **Called by:** build_frame.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### rebuild_effects_cache
- **File:** `wledtui`
- **Purpose:** UI rendering operation.
- **Parameters:** rebuild_effects_cache() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** EFFECTS, EFFECTS_CACHE_DIRTY, EFFECTS_ROW_NORMAL, EFFECTS_ROW_SELECTED, EFFECT_IDS, RIGHT_CACHE_WIDTH, RIGHT_INNER_WIDTH
- **External commands:** printf.
- **Calls:** ui_format_list_item.
- **Called by:** build_frame.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### rebuild_palettes_cache
- **File:** `wledtui`
- **Purpose:** UI rendering operation.
- **Parameters:** rebuild_palettes_cache() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** PALETTES, PALETTES_CACHE_DIRTY, PALETTES_ROW_NORMAL, PALETTES_ROW_SELECTED, RIGHT_CACHE_WIDTH, RIGHT_INNER_WIDTH
- **External commands:** None detected.
- **Calls:** ui_format_list_item.
- **Called by:** build_frame.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### rebuild_segments_cache
- **File:** `wledtui`
- **Purpose:** UI rendering operation.
- **Parameters:** rebuild_segments_cache() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** RIGHT_CACHE_WIDTH, RIGHT_INNER_WIDTH, SEGMENTS_CACHE_DIRTY, SEGMENTS_ROW_NORMAL, SEGMENTS_ROW_SELECTED, SEGMENT_TEXT
- **External commands:** None detected.
- **Calls:** ui_format_list_item.
- **Called by:** build_frame.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### mark_dirty_row
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** mark_dirty_row() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** 
- **External commands:** None detected.
- **Calls:** render_mark_dirty.
- **Called by:** update_topbar_line, update_inner_row.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### binding_desc_for_key
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** binding_desc_for_key(key) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** IFS, KEYBINDINGS
- **External commands:** printf.
- **Calls:** None detected.
- **Called by:** build_footer_hint.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### build_help_lines
- **File:** `wledtui`
- **Purpose:** UI rendering operation.
- **Parameters:** build_help_lines() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** HELP_LINES, IFS, KEYBINDINGS, KEYBINDING_SCOPES
- **External commands:** printf.
- **Calls:** format_key_label.
- **Called by:** build_frame.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### format_key_label
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** format_key_label(key) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** ESC
- **External commands:** printf.
- **Calls:** None detected.
- **Called by:** build_help_lines, build_footer_hint.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### current_tab_scope
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** current_tab_scope() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** TAB_INDEX
- **External commands:** printf.
- **Calls:** None detected.
- **Called by:** build_footer_hint.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### build_footer_hint
- **File:** `wledtui`
- **Purpose:** UI rendering operation.
- **Parameters:** build_footer_hint() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** IFS, TAB_INDEX
- **External commands:** printf.
- **Calls:** current_tab_scope, binding_desc_for_key, format_key_label.
- **Called by:** build_frame.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### update_topbar_line
- **File:** `wledtui`
- **Purpose:** UI rendering operation.
- **Parameters:** update_topbar_line(cols) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** APP_NAME, DEV_ONLINE, FRAME_LINES, RENDER_COLS
- **External commands:** None detected.
- **Calls:** current_device_id, device_display_name, ui_format_topbar, mark_dirty_row.
- **Called by:** handle_key, handle_up, handle_down.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### update_inner_row
- **File:** `wledtui`
- **Purpose:** UI rendering operation.
- **Parameters:** update_inner_row() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** FRAME_INNER_ROWS, FRAME_LINES, LEFT_LINES, RIGHT_LINES
- **External commands:** None detected.
- **Calls:** mark_dirty_row.
- **Called by:** update_list_selection, update_right_list_selection, refresh_status_pane, refresh_advanced_pane, refresh_segments_info.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### update_list_selection
- **File:** `wledtui`
- **Purpose:** UI rendering operation.
- **Parameters:** update_list_selection() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** FRAME_INNER_ROWS, LEFT_INNER_WIDTH, LEFT_LINES
- **External commands:** None detected.
- **Calls:** blank_line, update_inner_row.
- **Called by:** handle_key, handle_up, handle_down.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### update_right_list_selection
- **File:** `wledtui`
- **Purpose:** UI rendering operation.
- **Parameters:** update_right_list_selection() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** FRAME_INNER_ROWS, RIGHT_INNER_WIDTH, RIGHT_LINES
- **External commands:** None detected.
- **Calls:** blank_line, update_inner_row.
- **Called by:** handle_up, handle_down.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### refresh_status_pane
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** refresh_status_pane(id) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** FRAME_INNER_ROWS, RIGHT_INNER_WIDTH
- **External commands:** None detected.
- **Calls:** build_status_lines, update_inner_row.
- **Called by:** handle_key, handle_up, handle_down.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### refresh_advanced_pane
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** refresh_advanced_pane(id) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** FRAME_INNER_ROWS, RIGHT_INNER_WIDTH
- **External commands:** None detected.
- **Calls:** build_advanced_lines, update_inner_row.
- **Called by:** handle_key, handle_up, handle_down.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### refresh_segments_info
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** refresh_segments_info() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** COLOR_CHANNEL, FRAME_INNER_ROWS, RGB, RIGHT_INNER_WIDTH, RIGHT_LINES, SEGMENT_INDEX, SEGMENT_PRIMARY_COLOR, SEGMENT_TEXT, SEG_APPLY_ALL
- **External commands:** None detected.
- **Calls:** ui_pad_text, update_inner_row.
- **Called by:** handle_up, handle_down.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### build_status_lines
- **File:** `wledtui`
- **Purpose:** UI rendering operation.
- **Parameters:** build_status_lines(id, width) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEV_STATE_STALE, DEV_STATE_TS, DEV_UPTIME, DEV_VER, DEV_WIFI, LAST_REFRESH_SELECTED
- **External commands:** None detected.
- **Calls:** device_display_name, device_display_on, device_display_brightness, brightness_pending_marker, device_display_preset, set_right_line.
- **Called by:** refresh_status_pane, build_frame.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### build_presets_lines_locked
- **File:** `wledtui`
- **Purpose:** UI rendering operation.
- **Parameters:** build_presets_lines_locked(id, width) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEV_GET_PRESETS_INFLIGHT_PID, FRAME_INNER_ROWS, PRESETS_IDS, PRESETS_NAMES, PRESET_INDEX
- **External commands:** printf.
- **Calls:** set_right_line, preset_debug_log, set_right_list_line.
- **Called by:** build_presets_lines.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### build_presets_lines
- **File:** `wledtui`
- **Purpose:** UI rendering operation.
- **Parameters:** build_presets_lines(id, width) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** PRESETS_LOCK
- **External commands:** None detected.
- **Calls:** with_lock, build_presets_lines_locked.
- **Called by:** build_frame.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### build_effects_lines
- **File:** `wledtui`
- **Purpose:** UI rendering operation.
- **Parameters:** build_effects_lines(width) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEV_EFFECTS_PARSE_ERROR, EFFECTS, EFFECT_IDS, EFFECT_INDEX, EFFECT_PARAM, FRAME_INNER_ROWS, SEGMENT_INDEX, WLEDTUI_DEBUG
- **External commands:** printf.
- **Calls:** current_device_id, set_right_line, set_right_list_line.
- **Called by:** Entry/internal only.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### build_palettes_lines
- **File:** `wledtui`
- **Purpose:** UI rendering operation.
- **Parameters:** build_palettes_lines(width) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** FRAME_INNER_ROWS, PALETTES, PALETTE_INDEX, SEGMENT_INDEX
- **External commands:** None detected.
- **Calls:** set_right_line, set_right_list_line.
- **Called by:** Entry/internal only.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### build_segments_lines
- **File:** `wledtui`
- **Purpose:** UI rendering operation.
- **Parameters:** build_segments_lines(width) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** COLOR_CHANNEL, FRAME_INNER_ROWS, RGB, SEGMENTS, SEGMENT_INDEX, SEGMENT_PRIMARY_COLOR, SEGMENT_TEXT, SEG_APPLY_ALL
- **External commands:** None detected.
- **Calls:** set_right_line, set_right_list_line.
- **Called by:** Entry/internal only.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### build_advanced_lines
- **File:** `wledtui`
- **Purpose:** UI rendering operation.
- **Parameters:** build_advanced_lines(id, width) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEV_NL_DUR, DEV_STATE_JSON
- **External commands:** None detected.
- **Calls:** set_right_line, device_display_transition, device_display_nl_on, device_display_live.
- **Called by:** refresh_advanced_pane, build_frame.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### spinner_frame
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** spinner_frame() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** UI_SPINNER_FRAMES, UI_SPINNER_INDEX
- **External commands:** printf.
- **Calls:** None detected.
- **Called by:** current_modal_message.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### current_modal_message
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** current_modal_message() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** UI_BUSY_REFRESH, UI_BUSY_SCAN, UI_MODAL_ERROR_UNTIL, UI_MODAL_MESSAGE
- **External commands:** printf.
- **Calls:** now_ms, spinner_frame.
- **Called by:** build_frame.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### set_modal_error
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** set_modal_error(message) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** UI_DIRTY, UI_MODAL_ERROR_UNTIL, UI_MODAL_MESSAGE
- **External commands:** None detected.
- **Calls:** now_ms.
- **Called by:** process_discover_results, update_busy_states.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### begin_busy_scan
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** begin_busy_scan() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** UI_BUSY_SCAN, UI_DIRTY, UI_MODAL_ERROR_UNTIL, UI_MODAL_MESSAGE, UI_SPINNER_INDEX, UI_SPINNER_LAST_MS
- **External commands:** None detected.
- **Calls:** now_ms, start_discover_scan.
- **Called by:** handle_key.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### begin_busy_refresh
- **File:** `wledtui`
- **Purpose:** utility operation.
- **Parameters:** begin_busy_refresh(id) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** UI_BUSY_REFRESH, UI_BUSY_REFRESH_ERROR, UI_BUSY_REFRESH_ID, UI_DIRTY, UI_MODAL_ERROR_UNTIL, UI_MODAL_MESSAGE, UI_SPINNER_INDEX, UI_SPINNER_LAST_MS
- **External commands:** None detected.
- **Calls:** log_debug, device_display_name, net_key, now_ms, schedule_state_fetch, schedule_info_fetch, schedule_presets_fetch, schedule_effects_fetch, schedule_palettes_fetch.
- **Called by:** handle_key.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### update_busy_states
- **File:** `wledtui`
- **Purpose:** UI rendering operation.
- **Parameters:** update_busy_states() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEV_GET_STATE_INFLIGHT_PID, UI_BUSY_REFRESH, UI_BUSY_REFRESH_ERROR, UI_BUSY_REFRESH_ID, UI_DIRTY, UI_MODAL_ERROR_UNTIL, UI_MODAL_MESSAGE
- **External commands:** None detected.
- **Calls:** now_ms, set_modal_error.
- **Called by:** main_loop.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### update_spinner
- **File:** `wledtui`
- **Purpose:** UI rendering operation.
- **Parameters:** update_spinner() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** UI_BUSY_REFRESH, UI_BUSY_SCAN, UI_DIRTY, UI_SPINNER_FRAMES, UI_SPINNER_INDEX, UI_SPINNER_INTERVAL_MS, UI_SPINNER_LAST_MS
- **External commands:** None detected.
- **Calls:** now_ms.
- **Called by:** main_loop.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### overlay_help
- **File:** `wledtui`
- **Purpose:** UI rendering operation.
- **Parameters:** overlay_help(rows, cols) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** FRAME_LINES, HELP_LINES
- **External commands:** printf.
- **Calls:** box_top_line, box_bottom_line, ui_pad_text.
- **Called by:** build_frame.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### overlay_modal
- **File:** `wledtui`
- **Purpose:** UI rendering operation.
- **Parameters:** overlay_modal(rows, cols, message) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** FRAME_LINES
- **External commands:** printf.
- **Calls:** ui_pad_text, box_top_line, box_bottom_line.
- **Called by:** build_frame.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### build_frame
- **File:** `wledtui`
- **Purpose:** UI rendering operation.
- **Parameters:** build_frame(rows, cols) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** APP_NAME, COLOR_CHANNEL, DEVICE_IDS, DEVICE_LIST_DIRTY, DEV_EFFECTS_PARSE_ERROR, DEV_ONLINE, EFFECTS, EFFECTS_CACHE_DIRTY, EFFECTS_ROW_NORMAL, EFFECTS_ROW_SELECTED, EFFECT_INDEX, EFFECT_PARAM, FRAME_INNER_ROWS, FRAME_LINES, HELP_LINES, LEFT_CACHE_WIDTH, LEFT_INNER_WIDTH, LEFT_LINES…
- **External commands:** None detected.
- **Calls:** rebuild_device_cache, rebuild_presets_cache, rebuild_effects_cache, rebuild_palettes_cache, rebuild_segments_cache, current_device_id, device_display_name, ui_format_topbar, blank_line, ui_pad_text, build_status_lines, build_presets_lines, build_advanced_lines, box_top_line, box_bottom_line, build_help_lines, overlay_help, current_modal_message, overlay_modal, build_footer_hint, ui_format_footer.
- **Called by:** main_loop.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### handle_key
- **File:** `wledtui`
- **Purpose:** input handling operation.
- **Parameters:** handle_key(key) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** A, B, C, COLOR_CHANNEL, D, DEVICE_IDS, DEV_STATE_JSON, EFFECT_PARAM, LEFT_ROW_NORMAL, LEFT_ROW_SELECTED, SEGMENTS, SEG_APPLY_ALL, SELECTED_DEVICE_INDEX, SHOW_HELP, TAB_INDEX, TAB_NAMES, UI_DIRTY, Z
- **External commands:** jq.
- **Calls:** current_device_id, fetch_presets, fetch_effects, fetch_palettes, handle_up, handle_down, handle_left, handle_right, handle_enter, log_debug, device_display_name, begin_busy_refresh, handle_add_device, handle_delete_device, handle_edit_device, begin_busy_scan, handle_live_toggle, update_list_selection, update_topbar_line, refresh_status_pane, update_segment_texts, refresh_advanced_pane, handle_reboot.
- **Called by:** main_loop.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### handle_up
- **File:** `wledtui`
- **Purpose:** input handling operation.
- **Parameters:** handle_up() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** EFFECTS_ROW_NORMAL, EFFECTS_ROW_SELECTED, EFFECT_INDEX, LEFT_ROW_NORMAL, LEFT_ROW_SELECTED, PALETTES_ROW_NORMAL, PALETTES_ROW_SELECTED, PALETTE_INDEX, PRESETS_ROW_NORMAL, PRESETS_ROW_SELECTED, PRESET_INDEX, SEGMENTS_ROW_NORMAL, SEGMENTS_ROW_SELECTED, SEGMENT_INDEX, SELECTED_DEVICE_INDEX, TAB_INDEX
- **External commands:** None detected.
- **Calls:** adjust_preset_index, update_right_list_selection, refresh_segments_info, update_list_selection, update_topbar_line, current_device_id, refresh_status_pane, refresh_advanced_pane.
- **Called by:** handle_key.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### handle_down
- **File:** `wledtui`
- **Purpose:** input handling operation.
- **Parameters:** handle_down() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEVICE_IDS, EFFECTS, EFFECTS_ROW_NORMAL, EFFECTS_ROW_SELECTED, EFFECT_INDEX, LEFT_ROW_NORMAL, LEFT_ROW_SELECTED, PALETTES, PALETTES_ROW_NORMAL, PALETTES_ROW_SELECTED, PALETTE_INDEX, PRESETS_ROW_NORMAL, PRESETS_ROW_SELECTED, PRESET_INDEX, SEGMENTS, SEGMENTS_ROW_NORMAL, SEGMENTS_ROW_SELECTED, SEGMENT_INDEX…
- **External commands:** None detected.
- **Calls:** adjust_preset_index, update_right_list_selection, refresh_segments_info, update_list_selection, update_topbar_line, current_device_id, refresh_status_pane, refresh_advanced_pane.
- **Called by:** handle_key.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### handle_left
- **File:** `wledtui`
- **Purpose:** input handling operation.
- **Parameters:** handle_left() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** BRI_STEP, COLOR_CHANNEL, DEVICE_LIST_DIRTY, DEV_DESIRED_BRI, DEV_DESIRED_TRANSITION, DEV_UI_BRI, EFFECT_PARAM, SEGMENTS, SEGMENT_INDEX, SEG_APPLY_ALL, TAB_INDEX
- **External commands:** jq.
- **Calls:** current_device_id, device_display_brightness, clamp, enqueue_patch, device_display_transition, update_segment_texts.
- **Called by:** handle_key.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### handle_right
- **File:** `wledtui`
- **Purpose:** input handling operation.
- **Parameters:** handle_right() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** BRI_STEP, COLOR_CHANNEL, DEVICE_LIST_DIRTY, DEV_DESIRED_BRI, DEV_DESIRED_TRANSITION, DEV_UI_BRI, EFFECT_PARAM, SEGMENTS, SEGMENT_INDEX, SEG_APPLY_ALL, TAB_INDEX
- **External commands:** jq.
- **Calls:** current_device_id, device_display_brightness, clamp, enqueue_patch, device_display_transition, update_segment_texts.
- **Called by:** handle_key.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### handle_enter
- **File:** `wledtui`
- **Purpose:** input handling operation.
- **Parameters:** handle_enter(id) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEVICE_LIST_DIRTY, DEV_DESIRED_NL_ON, DEV_DESIRED_ON, DEV_DESIRED_PRESET, EFFECTS, EFFECT_IDS, EFFECT_INDEX, PALETTES, PALETTE_INDEX, PRESETS_LOCK, SEGMENTS, SEGMENT_INDEX, SEG_APPLY_ALL, TAB_INDEX
- **External commands:** jq.
- **Calls:** device_display_on, enqueue_patch, with_lock, get_selected_preset_id, update_segment_texts, device_display_nl_on.
- **Called by:** handle_key.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### handle_add_device
- **File:** `wledtui`
- **Purpose:** input handling operation.
- **Parameters:** handle_add_device() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEVICE_LIST_DIRTY, FULL_REDRAW, IFS
- **External commands:** tput.
- **Calls:** ui_clear, prompt_input, model_add_device, model_save_devices.
- **Called by:** handle_key.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### handle_delete_device
- **File:** `wledtui`
- **Purpose:** input handling operation.
- **Parameters:** handle_delete_device() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEVICE_LIST_DIRTY, SELECTED_DEVICE_INDEX, UI_DIRTY
- **External commands:** None detected.
- **Calls:** current_device_id, confirm_prompt, device_display_name, model_remove_device, model_save_devices.
- **Called by:** handle_key.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### handle_edit_device
- **File:** `wledtui`
- **Purpose:** input handling operation.
- **Parameters:** handle_edit_device() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEVICE_LIST_DIRTY, DEV_ALIAS, DEV_NAME, DEV_WLED_NAME, FULL_REDRAW, IFS, UI_DIRTY
- **External commands:** tput.
- **Calls:** current_device_id, ui_clear, prompt_input, device_display_name, is_valid_host, is_valid_port, model_remove_device, model_add_device, device_id, model_save_devices.
- **Called by:** handle_key.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### handle_live_toggle
- **File:** `wledtui`
- **Purpose:** input handling operation.
- **Parameters:** handle_live_toggle(id) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEV_DESIRED_LIVE
- **External commands:** jq.
- **Calls:** device_display_live, enqueue_patch.
- **Called by:** handle_key.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### handle_reboot
- **File:** `wledtui`
- **Purpose:** input handling operation.
- **Parameters:** handle_reboot(id) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** 
- **External commands:** jq.
- **Calls:** confirm_prompt, device_display_name, enqueue_patch.
- **Called by:** handle_key.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### smoke_test_brightness_repeat
- **File:** `wledtui`
- **Purpose:** testing operation.
- **Parameters:** smoke_test_brightness_repeat(id) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** BRI_STEP, DEV_BRI, DEV_DESIRED_BRI, DEV_ONLINE, DEV_UI_BRI, PATCH_DEBOUNCE_MS, PATCH_MIN_SEND_INTERVAL_MS, WLEDTUI_ASYNC_DRY_RUN, WLEDTUI_NET_DELAY_MS
- **External commands:** jq, printf.
- **Calls:** now_ms, enqueue_patch, process_network_queue, sleep_ms.
- **Called by:** smoke_test.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### smoke_test
- **File:** `wledtui`
- **Purpose:** testing operation.
- **Parameters:** smoke_test(target) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEV_GET_EFFECTS_INFLIGHT_PID, EFFECTS, F, HOST, IFS, PORT, TAB_INDEX
- **External commands:** jq, awk, head, printf.
- **Calls:** model_add_device, device_id, api_get_info, api_set_state, api_get_state, smoke_test_brightness_repeat, api_get_presets, parse_presets_tsv, start_get_request, sleep_ms, process_network_queue, load_effects_from_cache.
- **Called by:** Entry/internal only.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### main_loop
- **File:** `wledtui`
- **Purpose:** startup operation.
- **Parameters:** main_loop() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** APP_NAME, DEVICE_IDS, DEVICE_LIST_DIRTY, DEV_STATE_JSON, DEV_STATE_TS, FRAME_LINES, FULL_REDRAW, LAST_REFRESH_SELECTED, MODEL_DIRTY, RESIZED, SEGMENTS, UI_DIRTY, WINCH
- **External commands:** jq.
- **Calls:** model_load_devices, sync_desired_from_known, current_device_id, update_segment_texts, ui_init, set_term_title, process_network_queue, process_discover_results, update_busy_states, update_spinner, render_set_size, build_frame, render_draw_frame, render_has_dirty, render_flush_dirty, read_key, handle_key.
- **Called by:** Entry/internal only.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### api_base_url
- **File:** `lib/api.sh`
- **Purpose:** WLED API operation.
- **Parameters:** api_base_url(id) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEV_HOST, DEV_PORT
- **External commands:** printf.
- **Calls:** None detected.
- **Called by:** start_get_request, start_presets_request, start_patch_send, api_request.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### api_request
- **File:** `lib/api.sh`
- **Purpose:** WLED API operation.
- **Parameters:** api_request(method, id, path, payload) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** API_CONNECT_TIMEOUT, API_MAX_TIME, F, GET, H, URL, X
- **External commands:** curl, printf.
- **Calls:** api_base_url, device_display_name, log_debug.
- **Called by:** api_get_info, api_get_state, api_set_state, api_get_effects, api_get_palettes, api_get_presets.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### api_get_info
- **File:** `lib/api.sh`
- **Purpose:** WLED API operation.
- **Parameters:** api_get_info(id) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** GET
- **External commands:** None detected.
- **Calls:** api_request.
- **Called by:** smoke_test.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### api_get_state
- **File:** `lib/api.sh`
- **Purpose:** WLED API operation.
- **Parameters:** api_get_state(id) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** GET
- **External commands:** None detected.
- **Calls:** api_request.
- **Called by:** smoke_test.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### api_set_state
- **File:** `lib/api.sh`
- **Purpose:** WLED API operation.
- **Parameters:** api_set_state(id, payload) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** POST
- **External commands:** None detected.
- **Calls:** api_request.
- **Called by:** apply_state_payload, smoke_test.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### api_get_effects
- **File:** `lib/api.sh`
- **Purpose:** WLED API operation.
- **Parameters:** api_get_effects(id) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** GET
- **External commands:** None detected.
- **Calls:** api_request.
- **Called by:** Entry/internal only.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### api_get_palettes
- **File:** `lib/api.sh`
- **Purpose:** WLED API operation.
- **Parameters:** api_get_palettes(id) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** GET
- **External commands:** None detected.
- **Calls:** api_request.
- **Called by:** Entry/internal only.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### api_get_presets
- **File:** `lib/api.sh`
- **Purpose:** WLED API operation.
- **Parameters:** api_get_presets(id) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** GET
- **External commands:** printf.
- **Calls:** api_request.
- **Called by:** fetch_presets, smoke_test.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### api_probe_wled
- **File:** `lib/api.sh`
- **Purpose:** WLED API operation.
- **Parameters:** api_probe_wled(host, port) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** API_CONNECT_TIMEOUT, API_MAX_TIME
- **External commands:** curl, jq, printf.
- **Calls:** is_valid_host, is_valid_port.
- **Called by:** discover_devices_report.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### discover_parse_avahi
- **File:** `lib/discover.sh`
- **Purpose:** discovery operation.
- **Parameters:** discover_parse_avahi(service) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** IFS
- **External commands:** avahi-browse, printf.
- **Calls:** None detected.
- **Called by:** discover_primary, discover_secondary.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### discover_primary
- **File:** `lib/discover.sh`
- **Purpose:** discovery operation.
- **Parameters:** discover_primary() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** 
- **External commands:** avahi-browse.
- **Calls:** is_command, discover_parse_avahi.
- **Called by:** discover_devices_report.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### discover_secondary
- **File:** `lib/discover.sh`
- **Purpose:** discovery operation.
- **Parameters:** discover_secondary() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** 
- **External commands:** avahi-browse.
- **Calls:** is_command, discover_parse_avahi.
- **Called by:** discover_devices_report.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### discover_devices_report
- **File:** `lib/discover.sh`
- **Purpose:** discovery operation.
- **Parameters:** discover_devices_report() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** IFS
- **External commands:** printf.
- **Calls:** discover_primary, api_probe_wled, discover_secondary.
- **Called by:** start_discover_scan, discover_devices.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### discover_devices
- **File:** `lib/discover.sh`
- **Purpose:** discovery operation.
- **Parameters:** discover_devices() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEV_LAST_SEEN, IFS
- **External commands:** None detected.
- **Calls:** now_ts, model_add_device, device_id, discover_devices_report.
- **Called by:** Entry/internal only.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### device_id
- **File:** `lib/model.sh`
- **Purpose:** utility operation.
- **Parameters:** device_id(host, port) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** 
- **External commands:** printf.
- **Calls:** None detected.
- **Called by:** process_discover_results, handle_edit_device, smoke_test, discover_devices, model_add_device, model_load_devices.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### model_add_device
- **File:** `lib/model.sh`
- **Purpose:** device mgmt operation.
- **Parameters:** model_add_device(name, host, port) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEVICE_IDS, DEV_ALIAS, DEV_BACKOFF, DEV_BRI, DEV_DESIRED_BRI, DEV_DESIRED_LIVE, DEV_DESIRED_NL_ON, DEV_DESIRED_ON, DEV_DESIRED_PRESET, DEV_DESIRED_TRANSITION, DEV_EFFECTS_JSON, DEV_EFFECTS_PARSE_ERROR, DEV_EFFECTS_TS, DEV_GET_EFFECTS_INFLIGHT_PID, DEV_GET_INFO_INFLIGHT_PID, DEV_GET_PALETTES_INFLIGHT_PID, DEV_GET_PRESETS_INFLIGHT_PID, DEV_GET_STATE_INFLIGHT_PID…
- **External commands:** None detected.
- **Calls:** is_valid_host, is_valid_port, log_debug, device_id.
- **Called by:** process_discover_results, handle_add_device, handle_edit_device, smoke_test, discover_devices, model_load_devices.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### model_remove_device
- **File:** `lib/model.sh`
- **Purpose:** device mgmt operation.
- **Parameters:** model_remove_device(id) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEVICE_IDS, DEV_ALIAS, DEV_BACKOFF, DEV_BRI, DEV_DESIRED_BRI, DEV_DESIRED_LIVE, DEV_DESIRED_NL_ON, DEV_DESIRED_ON, DEV_DESIRED_PRESET, DEV_DESIRED_TRANSITION, DEV_EFFECTS_JSON, DEV_EFFECTS_PARSE_ERROR, DEV_EFFECTS_TS, DEV_GET_EFFECTS_INFLIGHT_PID, DEV_GET_INFO_INFLIGHT_PID, DEV_GET_PALETTES_INFLIGHT_PID, DEV_GET_PRESETS_INFLIGHT_PID, DEV_GET_STATE_INFLIGHT_PID…
- **External commands:** None detected.
- **Calls:** None detected.
- **Called by:** handle_delete_device, handle_edit_device.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### device_display_name
- **File:** `lib/model.sh`
- **Purpose:** utility operation.
- **Parameters:** device_display_name(id) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEV_ALIAS, DEV_HOST, DEV_NAME, DEV_PORT, DEV_WLED_NAME
- **External commands:** printf.
- **Calls:** None detected.
- **Called by:** preset_debug_log, effects_debug_log, palettes_debug_log, start_get_request, start_presets_request, rebuild_device_cache, update_topbar_line, build_status_lines, begin_busy_refresh, build_frame, handle_key, handle_delete_device, handle_edit_device, handle_reboot, api_request.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### model_load_devices
- **File:** `lib/model.sh`
- **Purpose:** device mgmt operation.
- **Parameters:** model_load_devices() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** CACHE_FILE, DEV_ALIAS, DEV_BRI, DEV_LAST_SEEN, DEV_LIVE, DEV_NL_DUR, DEV_NL_ON, DEV_ON, DEV_PRESET, DEV_STATE_JSON, DEV_STATE_STALE, DEV_STATE_TS, DEV_TRANSITION, DEV_WLED_NAME, IFS
- **External commands:** jq, printf.
- **Calls:** ensure_cache_dir, is_valid_host, is_valid_port, log_debug, device_id, model_add_device.
- **Called by:** main_loop.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### model_save_devices
- **File:** `lib/model.sh`
- **Purpose:** device mgmt operation.
- **Parameters:** model_save_devices() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** CACHE_FILE, CACHE_LOCK, DEVICE_IDS, DEV_ALIAS, DEV_HOST, DEV_IP, DEV_LAST_SEEN, DEV_NAME, DEV_PORT, DEV_STATE_JSON, DEV_STATE_TS, DEV_WLED_NAME
- **External commands:** jq.
- **Calls:** ensure_cache_dir, with_lock, write_file.
- **Called by:** apply_state_response, apply_info_response, process_discover_results, handle_add_device, handle_delete_device, handle_edit_device.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### render_init
- **File:** `lib/render.sh`
- **Purpose:** UI rendering operation.
- **Parameters:** render_init() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** K, RENDER_CIVIS, RENDER_CNORM, RENDER_EL, RENDER_RMCUP, RENDER_SGR0, RENDER_SMCUP
- **External commands:** printf.
- **Calls:** render_set_size.
- **Called by:** ui_init.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### render_set_size
- **File:** `lib/render.sh`
- **Purpose:** UI rendering operation.
- **Parameters:** render_set_size() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DIRTY_ROWS, FULL_REDRAW, PREV_LINES, RENDER_COLS, RENDER_ROWS
- **External commands:** tput.
- **Calls:** None detected.
- **Called by:** main_loop, render_init.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### render_cup
- **File:** `lib/render.sh`
- **Purpose:** UI rendering operation.
- **Parameters:** render_cup() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** 
- **External commands:** printf.
- **Calls:** None detected.
- **Called by:** render_draw_frame, render_flush_dirty.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### render_mark_dirty
- **File:** `lib/render.sh`
- **Purpose:** UI rendering operation.
- **Parameters:** render_mark_dirty() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DIRTY_ROWS
- **External commands:** None detected.
- **Calls:** None detected.
- **Called by:** mark_dirty_row.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### render_has_dirty
- **File:** `lib/render.sh`
- **Purpose:** UI rendering operation.
- **Parameters:** render_has_dirty() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DIRTY_ROWS
- **External commands:** None detected.
- **Calls:** None detected.
- **Called by:** main_loop.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### render_clear_dirty
- **File:** `lib/render.sh`
- **Purpose:** UI rendering operation.
- **Parameters:** render_clear_dirty() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DIRTY_ROWS
- **External commands:** None detected.
- **Calls:** None detected.
- **Called by:** render_draw_frame, render_flush_dirty.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### render_draw_frame
- **File:** `lib/render.sh`
- **Purpose:** UI rendering operation.
- **Parameters:** render_draw_frame() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** FULL_REDRAW, PREV_LINES, RENDER_EL, RENDER_ROWS, RENDER_SGR0
- **External commands:** printf.
- **Calls:** render_cup, render_clear_dirty.
- **Called by:** main_loop, render_flush_dirty.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### render_flush_dirty
- **File:** `lib/render.sh`
- **Purpose:** UI rendering operation.
- **Parameters:** render_flush_dirty() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DIRTY_ROWS, FULL_REDRAW, PREV_LINES, RENDER_EL, RENDER_SGR0
- **External commands:** printf.
- **Calls:** render_draw_frame, render_cup, render_clear_dirty.
- **Called by:** main_loop.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### render_shutdown
- **File:** `lib/render.sh`
- **Purpose:** teardown operation.
- **Parameters:** render_shutdown() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** RENDER_CNORM, RENDER_RMCUP, RENDER_SGR0
- **External commands:** printf.
- **Calls:** None detected.
- **Called by:** ui_restore.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### ui_init
- **File:** `lib/ui.sh`
- **Purpose:** UI rendering operation.
- **Parameters:** ui_init() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** EXIT, INT, TERM, UI_COLOR, UI_DIM_ON, UI_SEL_ON, UI_SGR0, UI_TOPBAR_ON
- **External commands:** tput, stty.
- **Calls:** color_support, render_init, ui_restore.
- **Called by:** main_loop.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### ui_restore
- **File:** `lib/ui.sh`
- **Purpose:** teardown operation.
- **Parameters:** ui_restore() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** 
- **External commands:** stty.
- **Calls:** render_shutdown.
- **Called by:** ui_init.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### ui_clear
- **File:** `lib/ui.sh`
- **Purpose:** UI rendering operation.
- **Parameters:** ui_clear() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** 
- **External commands:** tput.
- **Calls:** None detected.
- **Called by:** handle_add_device, handle_edit_device.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### ui_trim_text
- **File:** `lib/ui.sh`
- **Purpose:** UI rendering operation.
- **Parameters:** ui_trim_text(width) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** 
- **External commands:** printf.
- **Calls:** sanitize_for_display.
- **Called by:** box_top_line, ui_pad_text, ui_format_topbar, ui_format_footer, ui_format_list_item.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### ui_pad_text
- **File:** `lib/ui.sh`
- **Purpose:** UI rendering operation.
- **Parameters:** ui_pad_text(width) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** 
- **External commands:** printf.
- **Calls:** ui_trim_text.
- **Called by:** set_right_line, refresh_segments_info, overlay_help, overlay_modal, build_frame.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### ui_format_topbar
- **File:** `lib/ui.sh`
- **Purpose:** UI rendering operation.
- **Parameters:** ui_format_topbar(cols) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** UI_COLOR, UI_SGR0, UI_TOPBAR_ON
- **External commands:** printf.
- **Calls:** ui_trim_text.
- **Called by:** update_topbar_line, build_frame.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### ui_format_footer
- **File:** `lib/ui.sh`
- **Purpose:** UI rendering operation.
- **Parameters:** ui_format_footer(cols) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** UI_COLOR, UI_DIM_ON, UI_SGR0
- **External commands:** printf.
- **Calls:** ui_trim_text.
- **Called by:** build_frame.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### ui_format_list_item
- **File:** `lib/ui.sh`
- **Purpose:** UI rendering operation.
- **Parameters:** ui_format_list_item(width) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** UI_DIM_ON, UI_SEL_ON, UI_SGR0
- **External commands:** printf.
- **Calls:** ui_trim_text.
- **Called by:** set_right_list_line, rebuild_device_cache, rebuild_presets_cache, rebuild_effects_cache, rebuild_palettes_cache, rebuild_segments_cache.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### log_debug
- **File:** `lib/util.sh`
- **Purpose:** utility operation.
- **Parameters:** log_debug() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** DEBUG_LOG_FILE, WLEDTUI_DEBUG
- **External commands:** date, printf.
- **Calls:** ensure_cache_dir.
- **Called by:** preset_debug_log, effects_debug_log, palettes_debug_log, start_get_request, start_presets_request, begin_busy_refresh, handle_key, api_request, model_add_device, model_load_devices.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### strip_ansi
- **File:** `lib/util.sh`
- **Purpose:** utility operation.
- **Parameters:** strip_ansi() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** ANSI, E, Z
- **External commands:** sed, printf.
- **Calls:** None detected.
- **Called by:** sanitize_for_display.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### sanitize_for_display
- **File:** `lib/util.sh`
- **Purpose:** utility operation.
- **Parameters:** sanitize_for_display() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** ANSI
- **External commands:** tr, printf.
- **Calls:** strip_ansi.
- **Called by:** fetch_presets_locked, load_effects_from_cache, load_palettes_from_cache, start_get_request, start_presets_request, process_get_result, ui_trim_text, set_term_title, prompt_input, confirm_prompt.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### is_valid_host
- **File:** `lib/util.sh`
- **Purpose:** utility operation.
- **Parameters:** is_valid_host(host) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** A, IP, URL
- **External commands:** None detected.
- **Calls:** None detected.
- **Called by:** handle_edit_device, api_probe_wled, model_add_device, model_load_devices.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### is_valid_port
- **File:** `lib/util.sh`
- **Purpose:** utility operation.
- **Parameters:** is_valid_port(port) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** TCP, URL
- **External commands:** None detected.
- **Calls:** None detected.
- **Called by:** handle_edit_device, api_probe_wled, model_add_device, model_load_devices.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### write_file
- **File:** `lib/util.sh`
- **Purpose:** utility operation.
- **Parameters:** write_file(path) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** JSON
- **External commands:** printf.
- **Calls:** None detected.
- **Called by:** model_save_devices.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### now_ts
- **File:** `lib/util.sh`
- **Purpose:** utility operation.
- **Parameters:** now_ts() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** 
- **External commands:** date.
- **Calls:** None detected.
- **Called by:** start_get_request, start_presets_request, apply_state_response, apply_state_failure, apply_info_response, process_get_result, start_discover_scan, process_discover_results, discover_devices.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### now_ms
- **File:** `lib/util.sh`
- **Purpose:** utility operation.
- **Parameters:** now_ms() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** 
- **External commands:** date.
- **Calls:** None detected.
- **Called by:** sync_desired_from_known, apply_state_response, enqueue_patch, process_patch_queue, current_modal_message, set_modal_error, begin_busy_scan, begin_busy_refresh, update_busy_states, update_spinner, smoke_test_brightness_repeat.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### sleep_ms
- **File:** `lib/util.sh`
- **Purpose:** utility operation.
- **Parameters:** sleep_ms() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** BEGIN
- **External commands:** awk, sleep, printf.
- **Calls:** None detected.
- **Called by:** start_get_request, start_presets_request, start_patch_send, start_discover_scan, smoke_test_brightness_repeat, smoke_test.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### ensure_config_dir
- **File:** `lib/util.sh`
- **Purpose:** utility operation.
- **Parameters:** ensure_config_dir() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** CONFIG_DIR
- **External commands:** None detected.
- **Calls:** None detected.
- **Called by:** fetch_presets.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### ensure_cache_dir
- **File:** `lib/util.sh`
- **Purpose:** utility operation.
- **Parameters:** ensure_cache_dir() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** CACHE_DIR
- **External commands:** None detected.
- **Calls:** None detected.
- **Called by:** ensure_net_spool_dir, model_load_devices, model_save_devices, log_debug.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### clamp
- **File:** `lib/util.sh`
- **Purpose:** utility operation.
- **Parameters:** clamp() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** 
- **External commands:** printf.
- **Calls:** None detected.
- **Called by:** apply_state_failure, handle_left, handle_right.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### json_safe
- **File:** `lib/util.sh`
- **Purpose:** utility operation.
- **Parameters:** json_safe() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** 
- **External commands:** jq.
- **Calls:** None detected.
- **Called by:** Entry/internal only.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### is_command
- **File:** `lib/util.sh`
- **Purpose:** utility operation.
- **Parameters:** is_command() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** 
- **External commands:** command.
- **Calls:** None detected.
- **Called by:** discover_primary, discover_secondary.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### color_support
- **File:** `lib/util.sh`
- **Purpose:** utility operation.
- **Parameters:** color_support() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** NO_COLOR
- **External commands:** tput.
- **Calls:** None detected.
- **Called by:** ui_init.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### set_term_title
- **File:** `lib/util.sh`
- **Purpose:** utility operation.
- **Parameters:** set_term_title() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** 
- **External commands:** printf.
- **Calls:** sanitize_for_display.
- **Called by:** main_loop.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### with_lock
- **File:** `lib/util.sh`
- **Purpose:** utility operation.
- **Parameters:** with_lock() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** 
- **External commands:** flock.
- **Calls:** None detected.
- **Called by:** fetch_presets, process_get_result, build_presets_lines, handle_enter, model_save_devices.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### parse_presets_tsv
- **File:** `lib/util.sh`
- **Purpose:** utility operation.
- **Parameters:** parse_presets_tsv() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** 
- **External commands:** jq.
- **Calls:** None detected.
- **Called by:** fetch_presets_locked, smoke_test, run_test.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### parse_effects_tsv
- **File:** `lib/util.sh`
- **Purpose:** utility operation.
- **Parameters:** parse_effects_tsv() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** 
- **External commands:** jq.
- **Calls:** None detected.
- **Called by:** load_effects_from_cache.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### read_key
- **File:** `lib/util.sh`
- **Purpose:** utility operation.
- **Parameters:** read_key() (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** A, IFS, O
- **External commands:** printf.
- **Calls:** None detected.
- **Called by:** main_loop.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### prompt_input
- **File:** `lib/util.sh`
- **Purpose:** utility operation.
- **Parameters:** prompt_input(prompt) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** IFS
- **External commands:** tput, stty, printf.
- **Calls:** sanitize_for_display.
- **Called by:** handle_add_device, handle_edit_device.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### confirm_prompt
- **File:** `lib/util.sh`
- **Purpose:** utility operation.
- **Parameters:** confirm_prompt(prompt) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** IFS, N
- **External commands:** tput, stty, printf.
- **Calls:** sanitize_for_display.
- **Called by:** handle_delete_device, handle_reboot.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.

### run_test
- **File:** `scripts/dev_test_presets.sh`
- **Purpose:** utility operation.
- **Parameters:** run_test(name) (**Inference**, parsed from local assignments).
- **Inputs/Outputs:** Mutates in-memory shell state and/or stdout/exit status depending on call site.
- **Global interactions:** FAIL
- **External commands:** printf.
- **Calls:** parse_presets_tsv.
- **Called by:** Entry/internal only.
- **Error paths:** Usually relies on shell exit codes, explicit `|| true`, and caller-side checks.
- **Example call sites:** See `Called by` and call-graph docs.
- **Inference notes:** Dynamic shell evaluation means exact call edges may be incomplete.
