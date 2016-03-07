node 'jenkins.puppetlabs.demo' {
  include role::jenkins
}

node /master/ {
  include role::puppetmaster
}

node /mom/ {
  #include role::puppetmaster
  include role::master_of_masters
}

node /metrics/ {
  include role::metrics
}

node default {
  # Do nothing
}
