# == Class: profile::eyeunify::base
#
class profile::eyeunify::base {
  class { '::java':
    distribution => 'jre',
  }

  class { '::wildfly':
    java_home      => '/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.141-1.b16.el7_3.x86_64/jre',
    external_facts => true,
    mgmt_user      => {
      'username' => 'wildfly',
      'password' => 'hunter2',
    },
    properties     => {
      'jboss.bind.address'            => '0.0.0.0',
      'jboss.bind.address.management' => '0.0.0.0',
      'jboss.management.http.port'    => '9990',
      'jboss.management.https.port'   => '9993',
      'jboss.http.port'               => '8080',
      'jboss.https.port'              => '8443',
      'jboss.ajp.port'                => '8009',
    },
  }

  # Create cache directory
  file { '/var/cache/wget':
    ensure => directory,
    before => Class['::wildfly'],
  }
}
