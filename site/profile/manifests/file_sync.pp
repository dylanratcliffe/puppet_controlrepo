# Sets up file sync on an arbitrary host
#
class profile::file_sync (
  $puppetserver_conf_dir = '/etc/puppetlabs/puppetserver/conf.d'
) {
  Package <| tag == 'pe-master-packages' |>

  puppet_enterprise::trapperkeeper::pe_service { 'puppetserver': }

  Puppet_enterprise::Trapperkeeper::Bootstrap_cfg {
    container => 'puppetserver',
  }

  # Remove all confil files after install to get rid of default stuff
  exec { 'remove default config':
    command     => "rm -rf ${puppetserver_conf_dir}/*",
    path        => $facts['path'],
    refreshonly => true,
    subscribe   => Package['pe-puppetserver'],
  }

  # Ensure that all hocon settings come after the exec
  Exec['remove default config'] -> Pe_hocon_setting <| |> 

  # Create config files that were delete and are now unmanaged
  $new_config_files = [
    "${puppetserver_conf_dir}/metrics.conf",
    "${puppetserver_conf_dir}/webserver.conf",
    "${puppetserver_conf_dir}/global.conf",
  ]

  file { $new_config_files:
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  # Set the metrics server ID
  pe_hocon_setting { 'metrics.server-id':
    path   => "${puppetserver_conf_dir}/metrics.conf",
    value  => $facts['hostname'],
    notify => Service['pe-puppetserver'],
  }

  # Set the webserver port
  pe_hocon_setting { 'webserver.port':
    path   => "${puppetserver_conf_dir}/webserver.conf",
    value  => 8140,
    notify => Service['pe-puppetserver'],
  }

  # Set log config location
  pe_hocon_setting { 'global.logging-config':
    path   => "${puppetserver_conf_dir}/global.conf",
    value  => '/etc/puppetlabs/puppetserver/logback.xml',
    notify => Service['pe-puppetserver'],
  }

  # Removed the versioned code service as this brings in all of the puppetserver dependencies
  Puppet_enterprise::Trapperkeeper::Bootstrap_cfg <| title == 'file-sync-versioned-code-service' |> {
    ensure => 'absent',
  }

  # Set the authorization version as this is required
  pe_hocon_setting { 'authorization.version':
    path   => '/etc/puppetlabs/puppetserver/conf.d/auth.conf',
    value  => 1,
    notify => Service['pe-puppetserver'],
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
