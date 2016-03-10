class profile::metrics::collectd {
  $collectd_dir = '/etc/collectd'
  $collectd_version = '5.5.0'

  class { '::collectd':
    purge_config   => true,
    package_ensure => absent,
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
    strip   => 1,
    require => File[$collectd_dir],
  }

  exec { 'compile_collectd':
    command => 'configure',
    path    => "${collectd_dir}/collectd-${collectd_version}",
    creates => "${collectd_dir}/config.status",
    require => Staging::Deploy['collectd_source.tar.bz2']
  }

}
