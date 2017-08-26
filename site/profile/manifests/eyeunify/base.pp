# == Class: profile::eyeunify::base
#
class profile::eyeunify::base {
  class { '::java':
    distribution => 'jre',
  }

  class { '::wildfly':
    java_home => '/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.141-1.b16.el7_3.x86_64/jre',
    mgmt_user => {
      'username' => 'wildfly',
      'password' => 'hunter2',
    },
  }

  # Create cache directory
  file { '/var/cache/wget':
    ensure => directory,
    before => Class['::wildfly'],
  }
}
