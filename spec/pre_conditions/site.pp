#node 'centos6a.pdx.puppetlabs.demo' {
  service { 'pe-puppetserver':
    ensure => running,
  }
  #}

#node default {}
