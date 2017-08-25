class profile::eyeunify::core {
  include ::profile::eyeunify::base

  # Create users
  wildfly::resource { '/unify-default-users=properties':
    content => {
      'admin' => 'admin',
      'guest' => 'guest',
    },
  }

  # User roles
  wildfly::resource { '/unify-default-roles=properties':
    content => {
      'admin' => 'administrator,operator',
      'guest' => 'guest',
    },
  }

  file { ['/opt/eyeunify','/opt/eyeunify/mysql_connector']:
    ensure => directory,
  }

  archive { 'mysql_connector':
    ensure       => present,
    extract      => true,
    path         => '/tmp/mysql-connector-java-5.1.43.tar.gz',
    extract_path => '/opt/eyeunify/mysql_connector',
    source       => 'https://cdn.mysql.com/Downloads/Connector-J/mysql-connector-java-5.1.43.tar.gz',
    creates      => '/opt/eyeunify/mysql_connector/mysql-connector-java-5.1.43-bin.jar',
    cleanup      => true,
    require      => File['/opt/eyeunify/mysql_connector'],
  }

  wildfly::deployment { 'mysql-connector-java-5.1.43.tar.gz':
    source  => 'file:///opt/eyeunify/mysql_connector/mysql-connector-java-5.1.43-bin.jar',
    require => Archive['mysql_connector'],
  }

  wildfly::datasources::driver { 'Driver mysql':
    driver_name        => 'mysql',
    driver_module_name => 'org.mysql',
  }

  # wildfly::datasources::datasource { 'eyeUNIFY_datasource':
  #   name   => 'eyeUNIFY_datasource',
  #   config => { 'driver-name'    => 'mysql',
  #                       'connection-url' => 'jdbc:postgresql://10.10.10.10/petshop',
  #                       'jndi-name'      => 'java:jboss/datasources/petshopDS',
  #                       'user-name'      => 'petshop',
  #                       'password'       => 'password'
  #                     }
  # }
}
