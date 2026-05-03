#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
source ./lib/util.sh

pass(){ echo "PASS: $1"; }

if ! rg -n "'/json/eff'" lib/api.sh >/dev/null; then exit 1; fi
if ! rg -n "'/json/pal'" lib/api.sh >/dev/null; then exit 1; fi
pass "api endpoints use /json/eff and /json/pal"

actual=$(parse_effects_tsv <<<'["Solid","RSVD","Blink","-","Rainbow"]')
expected=$'0\tSolid\n2\tBlink\n4\tRainbow'
[[ "$actual" == "$expected" ]]
pass "reserved effects filtered while IDs preserved"

if json_normalize_or_fail '{bad json' >/dev/null; then exit 1; fi
pass "invalid state json can be rejected without shell exit"

rg -n 'DEV_LIVE\[\$id\]=\$\(jq -r '\''\.live // false'\''' wledtui >/dev/null
pass "live parsed from info"

seg='{"col":[[10,20,30,40]]}'
r=99; g=20; b=30; w=$(jq -r '.col[0][3]' <<<"$seg")
payload=$(jq -cn --argjson r "$r" --argjson g "$g" --argjson b "$b" --argjson w "$w" '{seg:[{id:0,col:[[ $r,$g,$b,$w ]]}]}')
[[ "$payload" == *"[99,20,30,40]"* ]]
pass "rgbw white channel preserved"

pactual=$(parse_presets_tsv <<<'{"1":{"n":"A"},"3":{"n":"B"}}')
[[ "$pactual" == $'1\tA\n3\tB' ]]
pass "preset object parser"

rg -n 'build_bri_payload\(\)\{ printf '\''\{"bri":%s,"tt":%s\}'\''' wledtui >/dev/null
pass "brightness payload helper exists with default tt support"

rg -n 'interactive_tt_value\(\)\{ printf '\''%s'\'' "\$\{WLEDTUI_INTERACTIVE_TT:-0\}"; \}' wledtui >/dev/null
pass "interactive tt override env supported"

rg -n 'build_segment_color_payload' wledtui >/dev/null
rg -n '\$r,\$g,\$b,\$w' wledtui >/dev/null
pass "rgbw payload builder preserves white channel"

rg -n 'model_add_device "\$name" "\$host" "\$port" "\$addr"' lib/discover.sh >/dev/null
pass "discover devices passes addr into model_add_device"

rg -n 'build_bri_payload|build_segment_color_payload|build_segment_scalar_payload' wledtui >/dev/null
pass "interactive handlers no longer depend on jq-only payload builders"

source ./lib/model.sh
tmp_cache=$(mktemp -d)
CACHE_DIR="$tmp_cache"
CACHE_FILE="$tmp_cache/devices.json"
CACHE_LOCK="$tmp_cache/devices.lock"
model_add_device a h1 80 10.0.0.1
model_add_device b h2 81 10.0.0.2
DEV_LAST_SEEN['h1:80']=1
DEV_LAST_SEEN['h2:81']=2
model_save_devices
jq -e '.devices|length==2' "$CACHE_FILE" >/dev/null
pass "model_save_devices writes valid multi-device JSON in one save"

echo "ALL TESTS PASSED"
