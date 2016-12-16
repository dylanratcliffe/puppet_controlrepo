class profile::mysql_server {
  include mysql::server

  file { '/etc/motd':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "This is a mysql server\nManaged by Puppet\n",
  }

  # Create the databases
  mysql_database { ['customers','products']:
    ensure  => present,
    require => Class['mtsql::server']
  }

  $mysql_users = [
    'dylan',
    'joe',
    'karl',
  ]

  # Create the users
  mysql_user { $mysql_users:
    ensure  => present,
    require => Class['mtsql::server']
  }

  # Purge any extra users or databases
  resources { ['mysql_database','mysql_user']:
    purge => true,
  }

  unless $::kernel == 'linux' {
    fail('The profile::mysql_server profile cannot be used on non-linux systems')
  }
}
