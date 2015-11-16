node 'bamboo.puppetlabs.demo' {
  include role::bamboo
}

node /master/ {
  include role::puppetmaster
}

node default {
  # Do nothing
}