class profile::hiera {
  class { '::hiera':
    datadir   => '"/etc/puppetlabs/code/environments/%{environment}/hieradata"',
    #hiera_yaml => '/etc/puppetlabs/puppet/hiera.yaml',
    hierarchy => [
      '%{environment}',
      'common',
    ],
  }
}
