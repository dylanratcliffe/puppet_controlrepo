node 'jenkins.puppetlabs.demo' {
  include role::jenkins
}

node /master/ {
  include role::puppetmaster
}

node /mom/ {
  include role::pupetmaster
  #include role::master_of_masters
}

node default {
  # Do nothing
}
