# == Class: profile::haproxy
#
# Hosts stats at :9090 puppet:puppet
#
# @param listening_pools A hash of listening pools
class profile::haproxy (
  Hash $listening_pools = {}
) {
  include ::haproxy

  $listening_pools.each |$name, $params| {
    haproxy::listen { $name:
      ipaddress => $::ipaddress,
      *         => $params,
    }
  }

  ini_setting { 'runinterval':
    ensure  => present,
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    section => 'agent',
    setting => 'runinterval',
    value   => '60',
  }

  haproxy::listen { 'stats':
    ipaddress => $facts['networking']['ip'],
    ports     => '9090',
    options   => {
      'mode'  => 'http',
      'stats' => [
        'uri /',
        'auth puppet:puppet',
      ],
    },
  }
}
