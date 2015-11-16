class profile::jenkins {
  class { '::jenkins':
    version            => 'latest',
    service_enable     => false,
    configure_firewall => true,
  }

  include ::vagrant

  package { 'bundler':
    ensure   => '1.10.5',
    provider => 'gem',
  }
}