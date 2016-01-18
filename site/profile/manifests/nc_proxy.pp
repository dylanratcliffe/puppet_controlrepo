class profile::nc_proxy {
  package { 'puppetclassify-puppet_gem':
    ensure   => latest,
    name     => 'puppetclassify',
    provider => 'puppet_gem',
  }

  node_group { 'PE Console':
    ensure               => 'present',
    classes              => {
      'pe_console_prune'                    => {
        'prune_upto' => '30'},
      'puppet_enterprise::license'          => {},
      'puppet_enterprise::profile::console' => {
        'console_services_api_listen_port'     => '44322',
        'console_services_api_ssl_listen_port' => '44333'}},
    environment          => 'production',
    id                   => '80f54dde-e4c7-4c57-bcaa-6ede60ae7248',
    override_environment => false,
    parent               => 'PE Infrastructure',
    rule                 => ['or', ['=', 'name', 'mom.puppetlabs.demo']],
  }

}