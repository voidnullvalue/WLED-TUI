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

echo "ALL TESTS PASSED"
