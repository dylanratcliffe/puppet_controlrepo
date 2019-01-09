class profile::cd4pe::connection (
  Sensitive[String] $license,
  String            $artifactory_user     = 'admin',
  Sensitive[String] $artifactory_password = Sensitive('password'),
  String            $artifactory_endpoint = "${facts['fqdn']}:8081",
  String            $cd4pe_endpoint       = "${facts['fqdn']}:8080",
  String            $cd4pe_root_login     = 'noreply@puppet.com',
  Sensitive[String] $cd4pe_root_pw        = Sensitive('puppetlabs'),
  String            $cd4pe_dump           = "${facts['fqdn']}:7000",
  String            $cd4pe_backend        = "${facts['fqdn']}:8000",
) {
  # Create a folder for these files
  file { '/etc/cd4pe':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }

  # Drop the license file
  file { '/etc/cd4pe/license.json':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0400',
    content => $license,
  }

  file { '/etc/cd4pe/connection_script.sh':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0700',
    content => epp('profile/cd4pe/connection_script.sh.epp', {
      'artifactory_user'     => $artifactory_user,
      'artifactory_password' => $artifactory_password.unwrap,
      'artifactory_endpoint' => $artifactory_endpoint,
      'cd4pe_endpoint'       => $cd4pe_endpoint,
      'cd4pe_root_login'     => $cd4pe_root_login,
      'cd4pe_root_pw'        => $cd4pe_root_pw.unwrap,
      'cd4pe_dump'           => $cd4pe_dump,
      'cd4pe_backend'        => $cd4pe_backend,
    }),
    require => File['/etc/cd4pe/license.json'],
  }

  exec { 'connect_instances':
    command     => '/etc/cd4pe/connection_script.sh',
    refreshonly => true,
    path        => $facts['path'],
    subscribe   => File['/etc/cd4pe/connection_script.sh'],
    require     => [
      Docker::Run['cd4pe-artifactory'],
      Docker::Run['cd4pe'],
    ],
  }
}
