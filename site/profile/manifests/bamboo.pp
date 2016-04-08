class profile::bamboo {
  class { '::bamboo':
    username       => 'bamboo',
    pass_hash      => '4b9c4b7a4a362c2ca77d9d0ba68952eec1f1f51772b74f4e08fdc2c40b2ccc9f33c2f1db0f4f64514f299eec6d641799d19b8da92b139fa7abc4719ea148d2ac',
    bamboo_version => '5.10.0',
    bamboo_home    => '/home/bamboo/data',
    bamboo_data    => '/var/bamboo/data',
    service_enable => false,
    java_manage    => false,
    db_manage      => false,
    require        => [Class['postgresql::server'],Class['java']],
    notify         => Exec['systemctl-daemon-reload'],
  }

  class { 'postgresql::server': }

  postgresql::server::db { 'bamboo':
    user     => 'bamboo',
    password => postgresql_password('bamboo', 'Dy(iHwfQRXT3KhZs>jDH@erTgM3X$tP]B&vazoAdFg.EGHXDqF'),
    require  => Class['postgresql::server'],
  }

  class { 'java':
    distribution => 'jdk',
    package      => 'java-1.8.0-openjdk-devel',
  }

  package { ['controlrepo','bundler']:
    ensure   => 'latest',
    provider => 'gem',
    require  => Package['ruby', 'ruby-dev'],
  }

  package { ['ruby', 'ruby-devel']:
    ensure => present,
  }


}
