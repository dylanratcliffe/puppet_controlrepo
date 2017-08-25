# == Class: profile::eyeunify::base
#
class profile::eyeunify::base {
  class { '::java':
    distribution => 'jre',
  }

  include ::wildfly

  # Create cache directory
  file { '/var/cache/wget':
    ensure => directory,
    before => Class['::wildfly'],
  }
}
