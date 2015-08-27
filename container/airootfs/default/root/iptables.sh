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
iptables -A INPUT -p tcp 
iptables -A INPUT -j DROP
###################################################################################################
iptables -A OUTPUT -p icmp -j DROP
iptables -A OUTPUT -p tcp -m multiport --dport 80,443.31279,31297 -j ACCEPT
iptables -A OUTPUT -p udp -m multiport --dport 53,67  -j ACCEPT
###################################################################################################

