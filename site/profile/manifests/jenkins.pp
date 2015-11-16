class profile::jenkins {
  class { '::jenkins':
    version     => 'latest',
    port        => 80,
    config_hash => {
    'HTTP_PORT' => { 'value' => '80' }
    },
  }

  firewall { '100 allow http  access':
    dport  => 80,
    proto  => tcp,
    action => accept,
  }
}