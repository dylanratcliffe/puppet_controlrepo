# == Class: profile::eyeunify::base
#
class profile::eyeunify::base {
  class { '::java':
    distribution => 'jre',
  }

  class { '::wildfly':
    java_home => '/usr/lib/jvm/java-1.8.0/'
  }

  # Create cache directory
  file { '/var/cache/wget':
    ensure => directory,
    before => Class['::wildfly'],
  }
}
