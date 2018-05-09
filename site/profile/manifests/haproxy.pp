# == Class: profile::haproxy
#
# @param listening_pools A hash of listening pools
class profile::haproxy (
  Hash $listening_pools = {}
) {
  include ::haproxy

  $listening_pools.each |$name, $params| {
    haproxy::listen { $name:
      ipaddress => $::ipaddress,
      *         => $params,
    }
  }
}
