# == Class: role::lb
#
# Creates a haproxy load balancer. New pools can be added in hiera
class role::lb {
  include ::profile::base
  include ::profile::haproxy
}
