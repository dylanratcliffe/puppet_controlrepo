class profile::bamboo {
  class { '::bamboo':
    username       => 'bamboo',
    pass_hash      => '4b9c4b7a4a362c2ca77d9d0ba68952eec1f1f51772b74f4e08fdc2c40b2ccc9f33c2f1db0f4f64514f299eec6d641799d19b8da92b139fa7abc4719ea148d2ac',
    #bamboo_version => '5.10.0',
    bamboo_home    => '/home/bamboo/data',
    bamboo_data    => '/var/bamboo/data',
    java_manage    => true,
    java_package   => 'java-1.8.0-openjdk-devel',
    db_manage      => true,
    #db_version     => '9.4.7',
    db_name        => 'bamboo_db',
    db_pass        => '2cPKZ7*rotGWQFwphsodo[BNoJqdDG;]NR)jnv}jJm.RCFGzRk',
  }
}
