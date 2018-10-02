# This class patches the Puppet MoMs to allow all nodes that are able to access
# the file-sync API to also be clients
class profile::file_sync::master_patch {
  # file { "${puppet_enterprise::master::file_sync::confdir}/conf.d/99_file_sync_override.conf":
  #   ensure  => file,
  #   owner   => 'root',
  #   group   => 'root',
  #   mode    => '0644',
  #   require => Package['pe-puppetserver'],
  # }

  # pe_hocon_setting { 'override file-sync.client-certnames':
  #   path    => "${puppet_enterprise::master::file_sync::confdir}/conf.d/99_file_sync_override.conf",
  #   setting => 'file-sync.client-certnames',
  #   value   => $puppet_enterprise::master::file_sync::certs_authorized_to_communicate_with_file_sync,
  #   type    => 'array',
  #   notify  => Service['pe-puppetserver'],
  # }
}
