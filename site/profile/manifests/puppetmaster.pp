class profile::puppetmaster {
  # Wait until we have installed the stuff first before including this class
  if count(query_resources("Class['profile::puppetmaster']","Package['puppetclassify_server']")) > 0 {
    include profile::puppetmaster::tuning
  }

  # Only include this if the master is running in AWS
  if $::ec2_metadata {
    # Make sure that we don't try to do thus intil the gems are installed
    # if count(query_resources("Class['profile::puppetmaster']","Class['autosign']")) > 0 {
    #   include profile::aws_nodes
    # }

    # Also enable the optional repo which is disabled in AWS
    yumrepo { 'rhui-REGION-rhel-server-optional':
      ensure  => 'present',
      enabled => '1',
      before  => Package['ruby-devel'],
    }
  }

  $server_gems = [
    'puppetclassify',
    'aws-sdk-core',
    'retries',
  ]

  # Create basic firewall rules
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

  $server_gems.each |$gem| {
    package { "${gem}_server":
      ensure   => present,
      name     => $gem,
      provider => 'puppetserver_gem',
      notify   => Service['pe-puppetserver'],
    }

    package { "${gem}_agent":
      ensure   => present,
      name     => $gem,
      provider => 'puppet_gem',
      notify   => Service['pe-puppetserver'],
    }
  }

  # Set up the default config for the AWS module
  # I will also need to do the following on the Puppet Master:
  #
  # export AWS_ACCESS_KEY_ID=your_access_key_id
  # export AWS_SECRET_ACCESS_KEY=your_secret_access_key

  ini_setting { 'aws region':
    ensure  => present,
    path    => "${settings::confdir}/puppetlabs_aws_configuration.ini",
    section => 'default',
    setting => 'region',
    value   => 'ap-southeast-2',
  }

  file { '/root/.aws':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }

  # Make sure that a user exists for me
  rbac_user { 'dylan':
    ensure       => 'present',
    display_name => 'Dylan Ratcliffe',
    email        => 'dylan.ratcliffe@puppet.com',
    password     => 'puppetlabs',
    roles        => [ 'Administrators' ],
  }

  # Add policy based autosigning using https://forge.puppet.com/danieldreier/autosign
  class { 'autosign':
    user  => 'pe-puppet',
    group => 'pe-puppet'
  }

  ini_setting {'policy-based autosigning':
    setting => 'autosign',
    path    => "${setings::confdir}/puppet.conf",
    section => 'master',
    value   => '/usr/local/bin/autosign-validator',
    require => Class['autosign'],
    notify  => Service['pe-puppetserver'],
  }
}
