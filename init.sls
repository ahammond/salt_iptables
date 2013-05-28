#!pydsl

from itertools import chain
from logging import getLogger

# Apparently Salt really doesn't like it when states take longer than 60s to do their job.
TIMEOUT = 5

l = getLogger('iptables')

iptables = '/etc/iptables-rules'
gather = __salt__['publish.publish']('*', 'network.ip_addrs', '', 'glob', '', TIMEOUT)
ip_addrs = sorted(list(chain.from_iterable(gather.values())))
l.debug('ip_addrs: %r', ip_addrs)

hosts = __pillar__.get('hosts', {})
legacy_ips = sorted(list(chain.from_iterable([x.get('legacy_ips', []) for x in hosts.values()])))
l.debug('legacy_ips: %r', legacy_ips)

state(iptables).file.managed(
    user='root', group='root', mode='600',
    source='salt://iptables/files{}.sls'.format(iptables),
    template='jinja',
    gather=gather,
    ipaddrs=ip_addrs,
    legacy_ips=legacy_ips
)
