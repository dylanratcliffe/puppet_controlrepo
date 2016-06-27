#
class profile::puppetmaster::api_auth {
  hocon_setting { 'allow all environment_classes':
    ensure  => present,
    path    => '/etc/puppetlabs/puppetserver/conf.d/auth.conf',
    setting => 'authorization.rules',
    type    => 'array_element',
    value   => {
      'allow'         => '*',
      'match-request' => {
        'method'       => 'get',
        'path'         => '/puppet/v3/environment_classes',
        'query-params' => {},
        'type'         => 'path'
      },
      'name'          => 'puppetlabs environment classes allow all',
      'sort-order'    => 490
    },
  }
}
