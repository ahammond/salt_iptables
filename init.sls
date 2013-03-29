{% set iptables = '/etc/iptables-rules' %}
{{ iptables }}:
  file.managed:
    - user: root
    - group: root
    - mode: 700
    - source: salt://iptables/files{{ iptables }}
