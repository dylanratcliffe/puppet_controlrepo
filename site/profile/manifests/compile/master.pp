class profile::compile::master {
  @@haproxy::balancermember { $::fqdn:
    listening_service => 'puppet00',
    server_names      => $::fqdn,
    ipaddresses       => $::networking['ip'],
    ports             => '8140',
    options           => 'check',
  }
}
