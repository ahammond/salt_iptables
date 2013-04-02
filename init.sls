#!pydsl

from itertools import chain

iptables = '/etc/iptables-rules'
gather = salt['publish.publish']('*', 'network.ip_addrs')
ip_addrs = list(chain.from_iterable(gather.values()))

state(iptables).file.managed(
    user='root', group='root', mode='700',
    source='salt://iptables/files{}.sls'.format(iptables),
    template='jinja',
    ipaddrs=ip_addrs
)
