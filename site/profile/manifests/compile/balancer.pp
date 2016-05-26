class profile::compile::balancer {
  include ::haproxy

  haproxy::listen { 'puppet00':
    collect_exported => true,
    ipaddress        => $::ipaddress,
    ports            => '8140',
  }
}
