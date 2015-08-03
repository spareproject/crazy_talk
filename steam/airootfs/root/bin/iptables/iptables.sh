#!/bin/bash -
###################################################################################################
iptables -F
iptables -X
iptables -t filter -F
iptables -t filter -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -t raw -F
iptables -t raw -X
iptables -t security -F
iptables -t security -X
###################################################################################################
iptables -N LO
iptables -N UDP
iptables -N TCP
###################################################################################################
iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP
###################################################################################################
iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED --ctproto tcp -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED --ctproto udp -j ACCEPT
iptables -A INPUT -i lo  -m conntrack --ctstate NEW -j ACCEPT
iptables -A INPUT -p udp -m conntrack --ctstate NEW -j UDP
iptables -A INPUT -p tcp -m conntrack --ctstate NEW -j TCP
iptables -A INPUT -j LOG --log-prefix "DROP" --log-level 6
iptables -A INPUT -j DROP
###################################################################################################
iptables -A TCP -p tcp --dport 31279 -j ACCEPT
iptables -A TCP -j LOG --log-prefix "TCP" --log-level 6
iptables -A TCP -j DROP
###################################################################################################
iptables -A UDP -j LOG --log-prefix "UDP" --log-level 6
iptables -A UDP -j DROP
###################################################################################################
