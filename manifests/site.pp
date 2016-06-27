node /jenkins/ {
  include role::jenkins
}

node /master/ {
  include role::puppetmaster::api
}

node /mom/ {
  #include role::puppetmaster
  include role::master_of_masters
}

node /metrics/ {
  include role::metrics
}

node default {
  include $::role
}
