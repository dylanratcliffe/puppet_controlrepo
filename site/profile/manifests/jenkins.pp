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

  package { ['ruby','ruby-devel','zlib','zlib-devel','rubygems','git','gcc-c++']:
    ensure => latest,
  }

  package { 'bundler':
    ensure   => '1.10.5',
    provider => 'gem',
    require  => Package['ruby','ruby-devel','rubygems'],
  }
}
