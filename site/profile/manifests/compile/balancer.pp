class profile::compile::balancer {
  class { '::haproxy':
    global_options => {
      'user'  => 'root',
      'group' => 'root',
    },
  }

  haproxy::listen { 'puppet00':
    collect_exported => true,
    ipaddress        => $::ipaddress,
    ports            => '8140',
  }
}
