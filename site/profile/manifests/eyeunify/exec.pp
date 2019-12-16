# == Class: profile::eyeunify::exec
#
class profile::eyeunify::exec {
  class { 'java' :
    version      => '8',
    distribution => 'jre',
  }

  # TODO: This is a work in progress
}
