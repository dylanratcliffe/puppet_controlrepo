class profile::metrics::collectd {
  $collectd_dir = '/etc/collectd'
  $collectd_version = '5.5.0'

  package { ['perl', 'perl-devel']:
    ensure => present,
  }

  class { '::collectd':
    purge_config   => true,
    package_ensure => absent,
    require        => Exec['install_collectd'],
  }

  include ::collectd::plugin::cpu
  include ::collectd::plugin::disk
  #include ::collectd::plugin::java
  include ::collectd::plugin::memory
  include ::collectd::plugin::interface

  collectd::plugin::write_graphite::carbon {'my_graphite':
    graphitehost   => 'metrics.methodology.com',
    graphiteport   => 2003,
    graphiteprefix => '',
    protocol       => 'tcp'
  }

  # Have to compile from source because the packages are ooold
  require ::gcc

  file { $collectd_dir:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  staging::deploy { "collectd-${collectd_version}.tar.bz2":
    target  => $collectd_dir,
    source  => "http://collectd.org/files/collectd-${collectd_version}.tar.bz2",
    require => File[$collectd_dir],
  }

  exec { 'compile_collectd':
    command => 'configure',
    cwd     => "${collectd_dir}/collectd-${collectd_version}",
    path    => "${::path}:${collectd_dir}/collectd-${collectd_version}",
    creates => "${collectd_dir}/collectd-${collectd_version}/config.status",
    require => Staging::Deploy["collectd-${collectd_version}.tar.bz2"],
  }

  exec { 'install_collectd':
    command => 'make all install',
    path    => "${::path}:${collectd_dir}/collectd-${collectd_version}",
    creates => '/opt/collectd',
    require => [Exec['compile_collectd'],Package['perl', 'perl-devel']],
  }

}
