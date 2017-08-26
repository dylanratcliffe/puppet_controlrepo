class profile::eyeunify::database {
  class { '::postgresql::globals':
    manage_package_repo => true,
    version             => '9.4',
  }

  class { '::postgresql::server': }

  # postgresql::server::db { 'eyeunify':
  #   user     => 'eyeunify',
  #   password => postgresql_password('eyeunify', 'hunter2'),
  # }
}
