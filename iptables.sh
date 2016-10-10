#!/bin/bash

set -e
# 全てのルールを削除 (初期化)
iptables -F
# ユーザー定義チェインを削除
iptables -X

# ポリシーの設定
# --------- 受信  全て破棄
iptables -P INPUT DROP
# --------- 送信  全て許可
iptables -P OUTPUT ACCEPT
# --------- 通過  全て破棄
iptables -P FORWARD DROP

# ループバック (自ホストからの通信は許可)
iptables -A INPUT -i lo -j ACCEPT

# 確立済みの通信は通す
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# SSH (XXX)
-A INPUT -m state --state NEW -m tcp -p tcp --dport XXX -j ACCEPT

# HTTP (80, 443)
-A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 443 -j ACCEPT

# Minecraft (25565)
-A INPUT -m state --state NEW -m tcp -p tcp --dport 25565 -j ACCEPT
