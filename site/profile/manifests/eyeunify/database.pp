class profile::eyeunify::database {
  class { '::mysql::server':
    root_password => 'hunter2',
  }
}
