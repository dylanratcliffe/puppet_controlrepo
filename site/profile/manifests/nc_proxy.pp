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
        'console_services_api_listen_port'     => '44322',
        'console_services_api_ssl_listen_port' => '44333'}},
    environment          => 'production',
    override_environment => false,
    parent               => 'PE Infrastructure',
  }

  node_group { 'PE Master':
    ensure               => 'present',
    classes              => {
      'pe_repo'                                          => {},
      'pe_repo::platform::el_7_x86_64'                   => {},
      'puppet_enterprise::profile::master'               => {
        'classifier_port'  => '44333',
        'r10k_private_key' => '/vagrant/ssh/maq_deploy',
        'r10k_remote'      => 'https://github.com/dylanratcliffe/puppet_controlrepo.git'},
      'puppet_enterprise::profile::master::mcollective'  => {},
      'puppet_enterprise::profile::mcollective::peadmin' => {}},
    environment          => 'production',
    override_environment => false,
    parent               => 'PE Infrastructure',
  }

  include ::nginx

  nginx::resource::upstream { 'regional_masters':
    members => [
      'mom.puppetlabs.demo:44333',
    ],
  }

  nginx::resource::vhost { $::networking['fqdn']:
    proxy       => 'https://regional_masters',
    ssl         => true,
    ssl_port    => '4433',
    listen_port => '4433',
  }
}