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
  }

  node_group { 'PE Master':
    ensure               => 'present',
    classes              => {
      'pe_repo'                                          => {},
      'pe_repo::platform::el_7_x86_64'                   => {},
      'puppet_enterprise::profile::master'               => {
        'classifier_port'  => '4433',
        'r10k_private_key' => '/vagrant/ssh/maq_deploy',
        'r10k_remote'      => 'https://github.com/dylanratcliffe/puppet_controlrepo.git'},
      'puppet_enterprise::profile::master::mcollective'  => {},
      'puppet_enterprise::profile::mcollective::peadmin' => {}},
    environment          => 'production',
    override_environment => false,
    parent               => 'PE Infrastructure',
  }

  # class { '::nginx':
  #   daemon_user => 'pe-puppet',
  # }
  #
  # nginx::resource::upstream { 'regional_masters':
  #   members => [
  #     'mom.puppetlabs.demo:44333',
  #     'master.mel.puppetlabs.demo:4433'
  #   ],
  # }
  #
  # nginx::resource::vhost { $::networking['fqdn']:
  #   proxy            => 'https://regional_masters',
  #   ssl              => true,
  #   ssl_port         => '4433',
  #   listen_port      => '4433',
  #   ssl_cert         => "/etc/puppetlabs/puppet/ssl/certs/${::networking['fqdn']}.pem",
  #   ssl_key          => "/etc/puppetlabs/puppet/ssl/private_keys/${::networking['fqdn']}.pem",
  #   ssl_crl          => '/etc/puppetlabs/puppet/ssl/ca/ca_crl.pem',
  #   ssl_trusted_cert => '/etc/puppetlabs/puppet/ssl/ca/ca_crt.pem',
  # }

  class { '::ruby':
    gems_version  => 'latest'
  }

  include ::epel

  class { '::nodejs':
    nodejs_dev_package_ensure => 'present',
    npm_package_ensure        => 'present',
    repo_class                => '::epel',
    require                   => Class['::ruby'],
  }

  package { 'http-proxy':
    ensure   => 'present',
    provider => 'npm',
    require  => Class['::nodejs']
  }

  file { '/opt/request_split':
    ensure => directory,
  }

  nodejs::npm { 'request_split from GitHub':
    ensure  => 'present',
    package => 'request_split',
    source  => 'dylanratcliffe/request_split',
    target  => '/opt/request_split',
    require => File['/opt/request_split'],
  }

  # vcsrepo { '/opt/request_split':
  #   ensure   => present,
  #   provider => git,
  #   source   => 'git://github.com/dylanratcliffe/request_split.git',
  #   revision => 'master',
  # }
}
