class profile::nc_proxy {
  package { 'puppetclassify':
    ensure   => latest,
    provider => 'puppet_gem',
  }

  # Make sure that the gem is installed before we try to use it
  Package['puppetclassify'] -> Node_group <||>

  node_group { 'PE Console':
    ensure               => 'present',
    classes              => {
      'pe_console_prune'                    => {
        'prune_upto' => '30'},
      'puppet_enterprise::license'          => {},
      'puppet_enterprise::profile::console' => {
        'console_services_api_listen_port'     => '4432',
        'console_services_api_ssl_listen_port' => '4433'}},
    environment          => 'production',
    override_environment => false,
    parent               => 'PE Infrastructure',
    rule                 => ['or', ['=', 'name', 'mom.puppetlabs.demo']],
  }

}