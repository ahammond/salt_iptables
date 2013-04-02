#!pydsl

from itertools import chain

iptables = '/etc/iptables-rules'
gather = __salt__['publish.publish']('*', 'network.ip_addrs')
ip_addrs = list(chain.from_iterable(gather.values())).sort()

state(iptables).file.managed(
    user='root', group='root', mode='600',
    source='salt://iptables/files{}.sls'.format(iptables),
    template='jinja',
    ipaddrs=ip_addrs
)
