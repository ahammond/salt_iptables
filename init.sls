/etc/iptables-rules:
  file.managed:
    - user: root
    - group: root
    - mode: 700
    - source: salt://iptables/salt_iptables_rules
