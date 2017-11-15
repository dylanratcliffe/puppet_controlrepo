class profile::compile::master (
  String $listening_pool = 'puppet00',
) {
  @@haproxy::balancermember { $::fqdn:
    listening_service => $listening_pool,
    server_names      => $::fqdn,
    ipaddresses       => $::networking['ip'],
    ports             => '8140',
    options           => 'check',
  }
}
