class profile::metrics::collectd {
  $collectd_dir = '/etc/collectd'

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

  staging::deploy { 'collectd_source.tar.bz2':
    target  => $collectd_dir,
    source  => 'http://collectd.org/files/collectd-5.5.0.tar.bz2',
    strip   => 1,
    require => File[$collectd_dir],
  }

  exec { 'compile_collectd':
    command => 'configure',
    path    => $collectd_dir,
    creates => "${collectd_dir}/config.status",
  }

  exec { }
}
