class profile::jenkins {
  class { '::jenkins':
    version => 'latest',
    port => 80,
    config_hash => {
      'HTTP_PORT' => { 'value' => '80' }
    },
    
  }
}