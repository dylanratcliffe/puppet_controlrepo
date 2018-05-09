class profile::eyeunify::database {
  class { '::postgresql::globals':
    manage_package_repo => true,
    version             => '9.4',
  }

  class { '::postgresql::server':
    listen_addresses => $facts['ip'],
  }

  postgresql::server::db { 'eyeunify':
    user     => 'eyeunify',
    password => postgresql_password('eyeunify', 'hunter2'),
    require  => Class['::postgresql::server'],
  }
}
