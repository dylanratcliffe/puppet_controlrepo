# == Class: role::eyeunify
#
class role::eyeunify {
  # Testing eyeunify role
  include ::profile::base
  include ::profile::eyeunify::base
  include ::profile::eyeunify::core
  include ::profile::eyeunify::database
  include ::profile::eyeunify::ctrl
  include ::profile::eyeunify::exec
}
