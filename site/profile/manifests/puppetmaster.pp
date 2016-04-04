class profile::puppetmaster {
  # Wait until we have installed the stuff first before including this class
  if count(query_resources("Class['profile::puppetmaster']","Package['puppetclassify']")) > 0 {
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

  package { 'puppetclassify':
    ensure   => present,
    provider => 'puppetserver_gem',
    notify   => Service['pe-puppetserver'],
  }
}
