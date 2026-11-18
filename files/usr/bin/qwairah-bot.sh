#!/bin/sh
get_ip() { IP=$(ip -4 addr show br-lan 2>/dev/null | awk '/inet / {print $2}' | cut -d'/' -f1); echo "${IP:-192.168.1.1}"; }
send_msg() {
    TOKEN=$(uci -q get qwairah_bot.general.token)
    CHAT_ID=$(uci -q get qwairah_bot.general.chat_id)
    [ -z "$TOKEN" ] || [ -z "$CHAT_ID" ] && return
    payload=$(jq -n --arg chat_id "$CHAT_ID" --arg text "$1" '{chat_id: $chat_id, text: $text, parse_mode: "HTML"}')
    curl -s -m 8 -X POST "https://api.telegram.org/bot${TOKEN}/sendMessage" -H "Content-Type: application/json" -d "$payload" >/dev/null 2>&1
}
sleep 15
send_msg "🟢 <b>تم تشغيل نظام QWAIRAH Router بنجاح!</b>%0A🌐 الآيبي: <code>$(get_ip)</code>"
while true; do sleep 60; done
