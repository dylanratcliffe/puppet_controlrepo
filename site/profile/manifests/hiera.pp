class profile::hiera {
  class { '::hiera':
    hierarchy => [
      '%{environment}',
      'common',
    ],
  }
}