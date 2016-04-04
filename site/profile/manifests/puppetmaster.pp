class profile::puppetmaster {
  # Wait until we have installed the stuff first before including this class
  if count(query_resources("Class['profile::puppetmaster']","Package['puppetclassify_server']")) > 0 {
    include profile::puppetmaster::tuning
  }

  firewall { '100 allow https access':
    dport  => 443,
    proto  => tcp,
    action => accept,
  }

  firewall { '101 allow mco access':
    dport  => 61613,
    proto  => tcp,
    action => accept,
  }

  firewall { '102 allow puppet access':
    dport  => 8140,
    proto  => tcp,
    action => accept,
  }

  package { 'puppetclassify_server':
    ensure   => present,
    name     => 'puppetclassify',
    provider => 'puppetserver_gem',
    notify   => Service['pe-puppetserver'],
  }

  package { 'puppetclassify_agent':
    ensure   => present,
    name     => 'puppetclassify',
    provider => 'puppet_gem',
    notify   => Service['pe-puppetserver'],
  }
}
