class profile::eyeunify::core (
  String $source = 'https://eyeunify.org/wp_root/wp-content/uploads/2016/11/eyeUNIFYcore_1_2_8953ad59.zip',
) {
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
    roles => 'administrator,operator',
  }

  wildfly::config::user { 'guest':
    password  => 'guest',
    file_name => 'unify-default-users.properties',
    require   => File['unify_users_file'],
  }

  wildfly::config::user_roles { 'guest':
    roles => 'administrator,operator',
  }

  # Create the security domain that eyeunify will use
  wildfly::security::domain { 'unify-default':
    login_modules => {
      'main-login-module' => {
        'code'           => 'UsersRoles',
        'flag'           => 'required',
        'domain'         => 'unify-default',
        'module_options' => {
          'usersProperties' => "${wildfly::dirname}/${wildfly::mode}/configuration/unify-default-users.properties",
          'rolesProperties' => "${wildfly::dirname}/${wildfly::mode}/configuration/application-roles.properties",
        },
      },
    },
  }

  # Actually deploy the core
  archive { 'eyeunify_core.zip':
    path         => '/tmp/eyeunify_core.zip',
    source       => $source,
    extract      => true,
    extract_path => '/tmp',
    creates      => '/tmp/eyeUNIFYcore_1_2_8953ad59.ear',
    cleanup      => true,
    user         => $wildfly::user,
    group        => $wildfly::user,
    require      => Package['unzip'],
  }

  wildfly::deployment { 'eyeunify_core.ear':
    source  => 'file:///tmp/eyeUNIFYcore_1_2_8953ad59.ear',
    require => Archive['eyeunify_core.zip'],
  }
}
