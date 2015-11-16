class profile::jenkins {
  class { '::jenkins':
    version            => 'latest',
    service_enable     => false,
    configure_firewall => true,
  }

  $plugins = [
    'promoted-builds',
    'credentials',
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
  ]

  jenkins::plugin { $plugins : }

  include ::vagrant

  package { 'bundler':
    ensure   => '1.10.5',
    provider => 'gem',
  }
}