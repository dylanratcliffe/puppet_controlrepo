class profile::jenkins {
  class { '::jenkins':
    version            => 'latest',
    service_enable     => false,
    configure_firewall => true,
  }

  $plugins = [
    'promoted-builds',
    'git-client',
    'scm-api',
    'mailer',
    'token-macro',
    'matrix-project',
    'ssh-credentials',
    'parameterized-trigger',
    'maven-plugin',
    'rebuild',
    'script-security',
    'junit',
    'credentials',
    'github',
    'git'
  ]

  jenkins::plugin { $plugins : }

  class { '::vagrant':
    version => '1.7.4',
  }

  package { ['ruby','ruby-devel']:
    ensure => '2.0.0',
  }

  package { 'rubygems':
    ensure => '2.0.14',
  }

  package { 'git':
    ensure => '1.8.3',
  }

  package { 'bundler':
    ensure   => '1.10.5',
    provider => 'gem',
    require  => Package['ruby','ruby-devel','rubygems'],
  }
}