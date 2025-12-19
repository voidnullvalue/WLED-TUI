# WLED TUI

Production-quality Linux terminal UI (TUI) to control **multiple** WLED instances using the WLED JSON HTTP API.

## Features
- Full-screen Bash TUI (tput/stty only) that works over SSH
- Bonjour/mDNS discovery via `avahi-browse`
- Manual device add/edit/remove
- Multi-instance overview with live status
- Full state controls: power, brightness, presets, effects, palettes, segments, colors, transition, nightlight, live mode, and reboot
- Robust networking with timeouts, backoff, and offline handling

## Dependencies
- Bash 5+
- `curl`
- `jq`
- `avahi-browse` (optional but recommended for discovery)

## Install
```bash
sudo apt-get install -y bash curl jq avahi-utils
```

## Usage
```bash
./wledtui
```

## Keybindings
- `q` quit
- `Tab` next tab
- `Shift-Tab` previous tab
- `↑/↓` navigate lists / devices
- `←/→` adjust values
- `Enter` apply/select
- `r` refresh now
- `a` add device (manual host:port)
- `d` delete device
- `e` edit device (manual host:port)
- `s` discovery scan
- `[` / `]` previous/next device
- `i` toggle effect control (speed/intensity)
- `c` toggle RGB channel in segment color editor
- `g` toggle apply-to-all segments
- `l` toggle live mode
- `b` reboot selected device
- `?` help overlay

## Troubleshooting
- **No devices found**: ensure `avahi-browse` is installed and you have mDNS access on your network.
- **Permission issues**: run `avahi-browse` as your user and ensure firewall rules allow mDNS (UDP 5353).
- **Offline devices**: the TUI uses short timeouts to keep the UI responsive and will back off retries.

## Files
- `wledtui`: main executable
- `lib/`: supporting Bash libraries
- `~/.config/wledtui/devices.json`: device cache

## License
MIT
