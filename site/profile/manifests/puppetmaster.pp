class profile::puppetmaster {
  # Wait until we have installed the stuff first
  $query_results = query_resources("Class['profile::puppetmaster']","Package['dslkjfng']")
  #if $query_results {
    #include profile::puppetmaster::tuning
  #}

  notify { count($query_results): }

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
