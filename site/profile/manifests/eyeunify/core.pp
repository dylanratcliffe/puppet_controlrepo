class profile::eyeunify::core {
  include ::profile::eyeunify::base
  include ::profile::eyeunify::core::database_connection

  # Create users
  file { 'unify_users_file':
    ensure  => file,
    path    => "${wildfly::dirname}/${wildfly::mode}/configuration/unify-default-users.properties",
    owner   => $wildfly::user,
    group   => $wildfly::group,
    mode    => '0644',
    require => Class['::wildfly::install'],
  }

  wildfly::config::user { 'admin':
    password  => 'admin',
    file_name => 'unify-default-users.properties',
    require   => File['unify_users_file'],
  }

  wildfly::config::user_roles { 'admin':
    roles   => 'administrator,operator',
  }

  wildfly::config::user { 'guest':
    password  => 'guest',
    file_name => 'unify-default-users.properties',
    require   => File['unify_users_file'],
  }

  wildfly::config::user_roles { 'guest':
    roles   => 'administrator,operator',
  }
}
