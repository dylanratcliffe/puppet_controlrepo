# == Class: profile::eyeunify::base
#
class profile::eyeunify::base {
  class { '::java':
    distribution => 'jre',
  }

  include ::wildfly
}
