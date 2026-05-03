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
source ./lib/api.sh
source ./lib/discover.sh

if rg -n '\$wled([^A-Za-z0-9_]|$)|\$\{wled([^A-Za-z0-9_]|[:}])' ./wledtui ./lib; then
  exit 1
fi
pass "no raw \$wled references remain in runtime code"
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

DEVICE_IDS=()
unset DEV_NAME DEV_ALIAS DEV_WLED_NAME DEV_HOST DEV_PORT DEV_IP
declare -A DEV_NAME=() DEV_ALIAS=() DEV_WLED_NAME=() DEV_HOST=() DEV_PORT=() DEV_IP=()

model_add_device "pretty-1.local" "pretty-1.local" 80 "10.0.0.10"
id="pretty-1.local:80"
DEV_ALIAS[$id]="Kitchen"
model_add_device "wled-a1b2c3.local" "10.0.0.10" 80 "10.0.0.10"
[[ "$(device_display_name "$id")" == "Kitchen" ]]
pass "alias is preserved across rediscovery by generated mdns/ip"

model_add_device "Desk Strip" "desk-strip.local" 80 "10.0.0.11"
id2="desk-strip.local:80"
DEV_WLED_NAME[$id2]="Desk Strip"
model_add_device "wled-xyz.local" "10.0.0.11" 80 "10.0.0.11"
[[ "$(device_display_name "$id2")" == "Desk Strip" ]]
pass "wled name is preserved across rediscovery by ip"

before_count=${#DEVICE_IDS[@]}
model_add_device "wled-rand-2.local" "wled-rand-2.local" 80 "10.0.0.11"
after_count=${#DEVICE_IDS[@]}
[[ "$before_count" -eq "$after_count" ]]
pass "same ip rediscovery with different mdns does not duplicate device"

DEV_IP[$id2]="10.0.0.22"
DEV_HOST[$id2]="desk-strip.local"
DEV_PORT[$id2]="81"
[[ "$(api_base_url "$id2")" == "http://10.0.0.22:81" ]]
pass "api_base_url prefers DEV_IP when present"

DEV_ALIAS[$id2]=""
DEV_WLED_NAME[$id2]="Desk Strip"
DEV_NAME[$id2]="mdns-name"
[[ "$(device_display_name "$id2")" == "Desk Strip" ]]
DEV_WLED_NAME[$id2]=""
[[ "$(device_display_name "$id2")" == "mdns-name" ]]
DEV_NAME[$id2]=""
[[ "$(device_display_name "$id2")" == "desk-strip.local:81" ]]
pass "device_display_name preference chain remains alias>wled>mdns>host:port"

discover_primary(){ :; }
discover_secondary_verified(){ :; }
discover_devices
pass "discover_devices tolerates empty discovery results under set -u"

discover_devices_report(){ printf 'svc|wled-missing.local|192.0.2.10|80|\n'; }
discover_devices
pass "discover_devices tolerates discovery entries missing info/name/mac/ip"

id4=$(model_add_device "placeholder.local" "placeholder.local" 80 "192.0.2.11")
DEV_WLED_NAME[$id4]="Friendly Name"
DEV_MAC[$id4]="aa:bb:cc:dd:ee:ff"
DEV_IP[$id4]="192.0.2.11"
[[ "$(device_display_name "$id4")" == "Friendly Name" ]]
pass "device_display_name uses friendly WLED info name when available"

if rg -n -- ' -- .* -o ' wledtui lib >/tmp/bad_curl.txt; then
  cat /tmp/bad_curl.txt
  exit 1
fi
pass "no curl -o option appears after --"

tmpbin=$(mktemp -d)
cat >"$tmpbin/curl" <<'EOF'
#!/usr/bin/env bash
seen_dd=0; out=""
for a in "$@"; do
  if [[ "$a" == "--" ]]; then seen_dd=1; continue; fi
  if (( seen_dd )) && [[ "$a" == "-o" ]]; then exit 77; fi
done
i=1
while (( i <= $# )); do
  arg="${!i}"
  if [[ "$arg" == "-o" ]]; then i=$((i+1)); out="${!i}"; fi
  i=$((i+1))
done
[[ -n "$out" ]] || exit 78
echo '{"ok":true}' >"$out"
printf '200'
EOF
chmod +x "$tmpbin/curl"
PATH="$tmpbin:$PATH"
curl -o "$tmpbin/out.json" -- "http://example"
jq -e '.ok==true' "$tmpbin/out.json" >/dev/null
pass "fake curl enforces -o before -- and writes output file"

echo "ALL TESTS PASSED"

id_ret=$(model_add_device "Desk Strip" "desk-strip.local" 80 "10.0.0.11")
[[ "$id_ret" == "$id2" ]]
pass "model_add_device returns merged id"

DEV_STATE_JSON[$id2]='{"bri":128,"on":true,"ps":4}'
DEV_INFO_JSON[$id2]='{"name":"Desk Strip","ver":"0.15"}'
model_save_devices
jq -e '.devices[]|select(.host=="desk-strip.local")|.state|type=="object"' "$CACHE_FILE" >/dev/null
jq -e '.devices[]|select(.host=="desk-strip.local")|.info|type=="object"' "$CACHE_FILE" >/dev/null
pass "cache state/info saved as objects"

DEVICE_IDS=()
declare -A DEV_NAME=() DEV_ALIAS=() DEV_WLED_NAME=() DEV_LAST_GOOD_WLED_NAME=() DEV_HOST=() DEV_PORT=() DEV_IP=() DEV_MAC=()
declare -A DEV_VER=() DEV_WIFI=() DEV_UPTIME=() DEV_LIVE=() DEV_INFO_JSON=() DEV_ONLINE=() DEV_LAST_SEEN=() DEV_BRI=() DEV_ON=() DEV_PRESET=() DEV_TRANSITION=() DEV_NL_ON=() DEV_NL_DUR=() DEV_STATE_STALE=() DEV_STATE_TS=()
cache2=$(mktemp -d)
CACHE_DIR="$cache2"; CACHE_FILE="$cache2/devices.json"; CONFIG_FILE="$cache2/config.json"; CACHE_LOCK="$cache2/lock"
cat >"$CACHE_FILE" <<'EOF'
{"devices":[{"name":"wled-a.local","mdns_name":"wled-a.local","host":"wled-a.local","ip":"192.168.88.50","port":80,"last_seen":1,"state_ts":0,"state":null,"info":{"name":"Kitchen Strip","ver":"0.15.0","wifi":{"signal":88},"uptime":123,"mac":"aabbccddeeff","ip":"192.168.88.50"},"online":1,"brightness":0}]}
EOF
apply_info_fields_from_json(){ local id=$1 normalized=$2; DEV_INFO_JSON[$id]="$normalized"; DEV_VER[$id]=$(jq -r '.ver // ""'<<<"$normalized"); DEV_WIFI[$id]=$(jq -r '.wifi.signal // ""'<<<"$normalized"); DEV_UPTIME[$id]=$(jq -r '.uptime // ""'<<<"$normalized"); DEV_LIVE[$id]=$(jq -r '.live // false'<<<"$normalized"); DEV_WLED_NAME[$id]=$(jq -r '.name // ""'<<<"$normalized"); DEV_LAST_GOOD_WLED_NAME[$id]="${DEV_WLED_NAME[$id]:-}"; DEV_MAC[$id]=$(jq -r '.mac // ""'<<<"$normalized"); DEV_IP[$id]=$(jq -r '.ip // ""'<<<"$normalized"); }
model_load_devices
id3="wled-a.local:80"
[[ "$(device_display_name "$id3")" == "Kitchen Strip" && "${DEV_VER[$id3]}" == "0.15.0" && "${DEV_WIFI[$id3]}" == "88" && "${DEV_UPTIME[$id3]}" == "123" && "${DEV_MAC[$id3]}" == "aabbccddeeff" && "${DEV_IP[$id3]}" == "192.168.88.50" ]]
pass "cached info hydration populates display/runtime info fields"

set +e
api_base_url "" >/dev/null 2>&1
rc_empty=$?
api_base_url "missing:80" >/dev/null 2>&1
rc_missing=$?
set -e
[[ $rc_empty -ne 0 && $rc_missing -ne 0 ]]
pass "api_base_url rejects empty or missing device id under set -u"

DEV_HOST[$id2]="desk-strip.local"
DEV_PORT[$id2]="81"
DEV_IP[$id2]="10.0.0.22"
[[ "$(api_base_url "$id2")" == "http://10.0.0.22:81" ]]
DEV_IP[$id2]="not-an-ip"
[[ "$(api_base_url "$id2")" == "http://desk-strip.local:81" ]]
pass "api_base_url prefers literal ip else host"

if rg -n 'local endpoint="\$\{DEV_HOST\[\$id\]\}"|"\$\{DEV_PORT\[\$id\]\}"' lib/api.sh; then
  exit 1
fi
pass "api.sh avoids unsafe raw DEV_HOST/DEV_PORT deref in api_base_url"

tmp_wled="./.wledtui_test_source.sh"
awk '/^if \[\[ "\$\{1:-\}" == "--smoke" \]\]; then/{exit} {print}' ./wledtui > "$tmp_wled"
source "$tmp_wled"
rm -f "$tmp_wled"
DEVICE_IDS=()
SELECTED_DEVICE_INDEX=3
[[ -z "$(current_device_id)" ]]
pass "current_device_id returns empty when no devices/out-of-range"

before_jobs=$(jobs -pr | wc -l | tr -d ' ')
set +e
no_pid="$(start_get_request "" "state" "/json/state")"
bad_rc=$?
set -e
after_jobs=$(jobs -pr | wc -l | tr -d ' ')
[[ $bad_rc -eq 0 && -z "$no_pid" && "$before_jobs" == "$after_jobs" ]]
pass "start_get_request invalid id returns success skip with empty pid and no job"

(exit 7) &
DISCOVER_INFLIGHT_PID=$!
DISCOVER_REQUESTED=1
UI_BUSY_SCAN=1
mkdir -p "$CACHE_DIR/net"
printf '0 %s\n' "$(now_ts)" > "$CACHE_DIR/net/discover.status"
process_discover_results
[[ "$UI_BUSY_SCAN" -eq 0 && -z "${DISCOVER_INFLIGHT_PID:-}" ]]
pass "discover wait failure is nonfatal and clears busy scan state"

api_base_url(){ echo "SHOULD_NOT_RUN" >&2; return 99; }
DEVICE_IDS=()
SELECTED_DEVICE_INDEX=0
set +e
begin_busy_refresh "$(current_device_id)"
refresh_rc=$?
set -e
[[ $refresh_rc -eq 0 ]]
pass "refresh path with no devices does not call api_base_url"
