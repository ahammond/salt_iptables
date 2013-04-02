{% set ip_addrs = salt['publish.publish']('*', 'network.ip_addrs') %}

{% set iptables = '/etc/iptables-rules' %}
{{ iptables }}:
  file.managed:
    - user: root
    - group: root
    - mode: 700
    - source: salt://iptables/files{{ iptables }}.sls
    - template: jinja
    - ipaddrs: {{ [item for sublist in ip_addrs.values() for item in sublist] }}
