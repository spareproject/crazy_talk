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
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP
###################################################################################################
iptables -A INPUT -p icmp -j DROP
iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED --ctproto tcp -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED --ctproto udp -j ACCEPT
iptables -A INPUT -p tcp --dport 31279 -j ACCEPT
iptables -A INPUT -p udp --dport 68 -j ACCEPT
iptables -A INPUT -p tcp -d 127.0.0.1 --dport 6010:6023 -j ACCEPT
iptables -A INPUT -j DROP
###################################################################################################
iptables -A OUTPUT -p icmp -j DROP
iptables -A OUTPUT -o LO -j ACCEPT
iptables -A OUTPUT -p tcp --sport 31279 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -p tcp -m multiport --dport 80,443 -j ACCEPT
iptables -A OUTPUT -p udp -m multiport --dport 53,67,31279  -j ACCEPT
###################################################################################################

