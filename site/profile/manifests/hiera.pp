class profile::hiera {
  class { '::hiera':
    datadir   => '"/etc/puppetlabs/code/environments/%{environment}/hieradata"',
    hierarchy => [
      '%{environment}',
      'global',
    ],
  }
}