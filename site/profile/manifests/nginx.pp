class profile::nginx {
  include ::nginx

  file { 'default_config_file':
    ensure  => absent,
    path    => "${nginx::conf_dir}/conf.d/default.conf",
    require => Class['nginx::config'],
    notify  => Class['nginx::service'],
  }
}
