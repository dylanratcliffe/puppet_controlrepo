node 'jenkins.puppetlabs.demo' {
  include role::jenkins
}

node /master/ {
  include role::puppetmaster
}

node default {
  # Do nothing
}