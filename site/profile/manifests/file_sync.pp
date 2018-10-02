# Sets up file sync on an arbitrary host
#
class profile::file_sync {
  Package <| tag == 'pe-master-packages' |>

  puppet_enterprise::trapperkeeper::pe_service { 'puppetserver': }

  Puppet_enterprise::Trapperkeeper::Bootstrap_cfg {
    container => 'puppetserver',
  }

  # Removed the versioned code service as this brings in all of the puppetserver dependencies
  Puppet_enterprise::Trapperkeeper::Bootstrap_cfg <| title == 'file-sync-versioned-code-service' |> {
    ensure => 'absent',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { 'jetty9-service':
    namespace => 'puppetlabs.trapperkeeper.services.webserver.jetty9-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { 'webrouting-service':
    namespace => 'puppetlabs.trapperkeeper.services.webrouting.webrouting-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { 'scheduler-service':
    namespace => 'puppetlabs.trapperkeeper.services.scheduler.scheduler-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { 'status-service':
    namespace => 'puppetlabs.trapperkeeper.services.status.status-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { 'authorization-service':
    namespace => 'puppetlabs.trapperkeeper.services.authorization.authorization-service',
  }

  puppet_enterprise::trapperkeeper::bootstrap_cfg { 'metrics-service':
    namespace => 'puppetlabs.trapperkeeper.services.metrics.metrics-service',
  }

  class { 'puppet_enterprise::master::file_sync':
    puppet_master_host                        => $puppet_enterprise::puppet_master_host,
    master_of_masters_certname                => $puppet_enterprise::puppet_master_host,
    localcacert                               => $puppet_enterprise::params::localcacert,
    puppetserver_jruby_puppet_master_code_dir => '/etc/puppetlabs/code',
    puppetserver_webserver_ssl_port           => '8140',
    storage_service_disabled                  => true,
  }
}
