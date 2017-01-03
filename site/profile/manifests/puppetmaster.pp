class profile::puppetmaster {
  # Wait until we have installed the stuff first before including this class
  if puppetdb_query('resources { type = "Package" and title = "puppetclassify_agent" }').count > 0 {
    include profile::puppetmaster::tuning
  }

  $server_gems = [
    'puppetclassify',
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

  # Make sure that a user exists for me
  rbac_user { 'dylan':
    ensure       => 'present',
    display_name => 'Dylan Ratcliffe',
    email        => 'dylan.ratcliffe@puppet.com',
    password     => 'puppetlabs',
    roles        => [ 'Administrators' ],
  }

  # Create a Developers role
  rbac_role { 'Developers':
    ensure      => 'present',
    description => 'Can run Puppet, deploy code and use PuppetDB',
    permissions => [
      {
        'action'      => 'edit_child_rules',
        'instance'    => '*',
        'object_type' => 'node_groups'
      }, {
        'action'      => 'edit_params_and_vars',
        'instance'    => '*',
        'object_type' => 'node_groups'
      }, {
        'action'      => 'edit_classification',
        'instance'    => '*',
        'object_type' => 'node_groups'
      }, {
        'action'      => 'view',
        'instance'    => '*',
        'object_type' => 'console_page'
      }, {
        'action'      => 'view_data',
        'instance'    => '*',
        'object_type' => 'nodes'
      }, {
        'action'      => 'set_environment',
        'instance'    => '*',
        'object_type' => 'node_groups'
      }, {
        'action'      => 'modify_children',
        'instance'    => '*',
        'object_type' => 'node_groups'
      }, {
        'action'      => 'deploy_code',
        'instance'    => '*',
        'object_type' => 'environment'
      }, {
        'action'      => 'view',
        'instance'    => '*',
        'object_type' => 'node_groups'
      }, {
        'action'      => 'accept_reject',
        'instance'    => '*',
        'object_type' => 'cert_requests'
      }, {
        'action'      => 'run',
        'instance'    => '*',
        'object_type' => 'puppet_agent'
      }
    ],
  }

  # Import all exported console users
  Console::User <<| |>>

  # Add policy based autosigning using https://forge.puppet.com/danieldreier/autosign
  class { 'autosign':
    user     => 'pe-puppet',
    group    => 'pe-puppet',
    settings => {
      'general'   => {
        'loglevel' => 'DEBUG',
      },
      'jwt_token' => {
        'secret' => 'DkCieMT9UyMvg(JDQeuJm%Qao>.p*GLxYg}kaw%ExAfRDvh7Mz'
      },
    },
  }

  ini_setting {'policy-based autosigning':
    setting => 'autosign',
    path    => "${settings::confdir}/puppet.conf",
    section => 'master',
    value   => '/opt/puppetlabs/puppet/bin/autosign-validator',
    require => Class['autosign'],
    notify  => Service['pe-puppetserver'],
  }
}
