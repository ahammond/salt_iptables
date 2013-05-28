*filter
:INPUT DROP [141:8535]
:FORWARD ACCEPT [44:2640]
:OUTPUT ACCEPT [162484:28266479]
-A INPUT -p icmp -j ACCEPT
-A INPUT -i tun+ -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -p tcp -m tcp --dport 22 -m state --state NEW -j ACCEPT
-A INPUT -p udp --dport 1194 -m state --state NEW -j ACCEPT
-A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
{# role specific inbound open ports -#}
-A INPUT -p tcp -m tcp --dport 80 -m state --state NEW -j ACCEPT
-A INPUT -p tcp -m tcp --dport 443 -m state --state NEW -j ACCEPT
{# allow the VPN -#}
-A INPUT -s 10.8.0.0/16 -j ACCEPT
{# ports at the office -#}
-A INPUT -s 98.173.193.67 -p tcp -j ACCEPT
-A INPUT -s 98.173.193.68 -p tcp -j ACCEPT
{# legacy nodes; these should be removed as migration proceeds -#}
{% if legacy_ips is defined -%}
{%   for legacy_ip in legacy_ips -%}
-A INPUT -s {{ legacy_ip }}/32 -j ACCEPT
{%   endfor -%}
{% endif -%}
{% if 'rackspace' == grains['datacenter'] -%}
{%   for ipaddr in ipaddrs -%}
{%     if ipaddr.startswith('10.') and not ipaddr.startswith('10.8') -%}
-A INPUT -s {{ ipaddr }}/32 -j ACCEPT
{%     endif -%}
{%   endfor -%}
{% else -%}
{# Must be Incero boxes. Support the point-to-point link. -#}
-A INPUT -s 192.168.0.0/16 -j ACCEPT
{% endif -%}
{# junk the rest -#}
-A INPUT -p tcp -j REJECT --reject-with tcp-reset
-A INPUT -p udp -j REJECT --reject-with icmp-port-unreachable
-A FORWARD -i tun+ -j ACCEPT
COMMIT
# Number of minions responding: {{ (len(gather.keys()))|int }}
