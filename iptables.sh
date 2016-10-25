#!/bin/bash

set -e
# 全てのルールを削除 (初期化)
iptables -F
# ユーザー定義チェインを削除
iptables -X

# ループバック (自ホストからの通信は許可)
iptables -A INPUT -i lo -j ACCEPT

# 確立済みの通信は通す
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# ping(icmp)許可
iptables -I INPUT -p icmp --icmp-type 0 -j ACCEPT
iptables -I INPUT -p icmp --icmp-type 8 -j ACCEPT

# SSH (XXX)
iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport XXX -j ACCEPT

# HTTP (80, 443)
iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 443 -j ACCEPT

# Minecraft (25565)
iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 25565 -j ACCEPT

# TeamSpeak3
iptables -A INPUT -m state --state NEW -m udp -p udp --dport 9987 -j ACCEPT
# Query
# iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 10011 -j ACCEPT
# ファイル転送
iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 30033 -j ACCEPT

# ポリシーの設定
# --------- 受信  全て破棄
iptables -P INPUT DROP
# --------- 送信  全て許可
iptables -P OUTPUT ACCEPT
# --------- 通過  全て破棄
iptables -P FORWARD DROP
