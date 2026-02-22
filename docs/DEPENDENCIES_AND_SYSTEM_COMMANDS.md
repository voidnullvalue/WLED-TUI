# Dependencies and System Commands

See [File Map](./FILE_MAP.md) and [Function Index](./FUNCTION_INDEX.md).

## Bash/runtime features
- Bash arrays + associative arrays (`declare -a/-A`) for in-memory model.
- `trap` for resize (`WINCH`) and shutdown restoration (`EXIT INT TERM`).
- Process substitution `< <(...)`, background jobs `(...) &`, `wait`, `kill -0`.
- Nameref (`local -n`) used in list selection update helpers.
- `set -euo pipefail`, `shopt -s lastpipe` globally in scripts.

## External commands
- `curl`: all WLED HTTP I/O, with `--connect-timeout`, `--max-time`, `--fail`, `--silent`, `--show-error`, `--write-out`.
- `jq`: JSON parse/transform/validation and patch building.
- `avahi-browse`: mDNS discovery (`-rtp`), optional dependency.
- `tput`: terminal size, styles, clear, cursor visibility.
- `stty`: disable/restore echo during TUI prompts.
- `flock`: lock files for safe cache/presets critical sections.
- `mktemp`: capture jq parse stderr for diagnostics.
- text utils: `awk`, `sed`, `tr`, `wc`, `head`, `cat`, `mv`, `rm`, `date`, `sleep`.

## Missing dependency behavior
- Missing `avahi-browse`: discovery returns no entries (graceful no-op).
- Missing `jq`/`curl`/`tput`/`stty`/`flock`: script likely fails due to `set -e` (hard dependency).

## Portability notes
- `date +%s%3N` for milliseconds may not work on BSD/macOS `date`.
- Assumes GNU-like tools and Linux terminal semantics.
