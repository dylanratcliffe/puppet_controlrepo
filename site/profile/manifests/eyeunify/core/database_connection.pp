# == Class: profile::eyeunify::core::database_connection
#
class profile::eyeunify::core::database_connection (
    String $database_server = 'localhost',
    String $database_name   = 'eyeunify',
    String $username        = 'eyeunify',
    String $password        = 'hunter2',
) {
  wildfly::config::module { 'org.postgresql':
    source       => 'http://central.maven.org/maven2/org/postgresql/postgresql/9.4-1206-jdbc42/postgresql-9.4-1206-jdbc42.jar',
    dependencies => ['javax.api', 'javax.transaction.api'],
    require      => Class['wildfly'],
  }

  wildfly::datasources::driver { 'Driver postgresql':
    driver_name                     => 'postgresql',
    driver_module_name              => 'org.postgresql',
    driver_xa_datasource_class_name => 'org.postgresql.xa.PGXADataSource',
    require                         => Wildfly::Config::Module['org.postgresql'],
  }

  wildfly::datasources::datasource { 'eyeUNIFY_datasource':
    name    => 'eyeUNIFY_datasource',
    config  => {
      'driver-name'           => 'postgresql',
      'connection-url'        => "jdbc:postgresql://${database_server}/${database_name}",
      'jndi-name'             => 'java:/datasources/heliopsis',
      'transaction-isolation' => 'TRANSACTION_SERIALIZABLE',
      'user-name'             => $username,
      'password'              => $password,
    },
    require => Wildfly::Datasources::Driver['Driver postgresql'],
  }
}
