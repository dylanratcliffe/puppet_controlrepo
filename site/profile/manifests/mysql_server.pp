class profile::mysql_server {
  include mysql::server

  file { '/etc/motd':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "This is a mysql server\nManaged by Puppet\n",
  }

  mysql_user { 'dylan@localhost':
    ensure  => present,
    require => Class['mysql::server'],
  }

  unless $::kernel == 'linux' {
    fail('The profile::mysql_server profile cannot be used on non-linux systems')
  }
}
