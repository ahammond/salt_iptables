#!pydsl

from itertools import chain

# Apparently Salt really doesn't like it when states take longer than 60s to do their job.
TIMEOUT = 5

iptables = '/etc/iptables-rules'
gather = __salt__['publish.publish']('*', 'network.ip_addrs', '', 'glob', '', TIMEOUT)
ip_addrs = sorted(list(chain.from_iterable(gather.values())))

hosts = __pillar__.get('hosts', {})
legacy_ips = sorted(list(chain.from_iterable([x.get('legacy_ips', []) for x in hosts.values()])))

state(iptables).file.managed(
    user='root', group='root', mode='600',
    source='salt://iptables/files{}.sls'.format(iptables),
    template='jinja',
    gather=gather,
    ipaddrs=ip_addrs,
    legacy_ips=legacy_ips
)
