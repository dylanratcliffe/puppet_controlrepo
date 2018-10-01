# Sets up file sync on an arbitrary host
#
class profile::file_sync {
  Package <| tag == 'pe-master-packages' |>

  puppet_enterprise::trapperkeeper::pe_service { 'puppetserver': }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { 'jruby-puppet-pooled-service' :
    namespace => 'puppetlabs.services.jruby.jruby-puppet-service',
  }

  class { 'puppet_enterprise::master::file_sync':
    puppet_master_host                        => $puppet_enterprise::puppet_master_host,
    master_of_masters_certname                => $puppet_enterprise::puppet_master_host,
    localcacert                               => $puppet_enterprise::params::localcacert,
    puppetserver_jruby_puppet_master_code_dir => '/etc/puppetlabs/code',
    puppetserver_webserver_ssl_port           => '8140',
    storage_service_disabled                  => false,
  }
}
