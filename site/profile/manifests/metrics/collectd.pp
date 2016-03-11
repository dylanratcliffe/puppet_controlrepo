class profile::metrics::collectd {
  $collectd_dir = '/etc/collectd'
  $collectd_version = '5.1.0'

  $dependencies = [
    'perl',
    'perl-devel',
    'perl-CGI',
    'perl-Collectd',
    'perl-Config-General',
    'perl-Time-HiRes',
    'perl-URI'
  ]
  
  package { $dependencies:
    ensure => present,
    before => Package['collectd'],
  }

  class { '::collectd':
    purge_config   => true,
    package_ensure => present,
    require        => Staging::File["collectd-${collectd_version}-1.rft.src.rpm"],
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

  file { $collectd_dir:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  staging::file { "collectd-${collectd_version}-1.rft.src.rpm":
    target  => "${collectd_dir}/collectd-${collectd_version}-1.rft.src.rpm",
    source  => "http://pkgs.repoforge.org/collectd/collectd-${collectd_version}-1.rft.src.rpm",
    require => File[$collectd_dir],
  }

  Package <| title == 'collectd' |> {
    source   => "${collectd_dir}/collectd-${collectd_version}-1.rft.src.rpm",
    provider => 'rpm',
  }
}
