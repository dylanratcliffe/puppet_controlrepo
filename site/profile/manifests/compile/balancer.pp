class profile::compile::balancer (
  $listening_pool = 'puppet00',
) {
  class { '::haproxy':
    global_options => {
      'user'  => 'root',
      'group' => 'root',
    },
  }

  haproxy::listen { $listening_pool:
    collect_exported => true,
    ipaddress        => $::ipaddress,
    ports            => '8140',
  }

  haproxy::listen { $listening_pool:
    collect_exported => true,
    ipaddress        => $::ipaddress,
    ports            => '8142',
  }
}
