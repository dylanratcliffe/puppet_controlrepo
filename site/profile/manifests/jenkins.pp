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
    'github',
    'git',
    'workflow-aggregator',
    'puppet-enterprise-pipeline',
  ]

  jenkins::plugin { $plugins : }

  include profile::base

  package { 'bundler':
    ensure   => '1.10.5',
    provider => 'gem',
    require  => Package['ruby'],
  }

  include ::nginx

  # Include a reverse proxy in front
  nginx::resource::vhost { $::hostname:
    listen_port    => 80,
    listen_options => 'default_server',
    proxy          => 'http://localhost:8080',
  }
}
