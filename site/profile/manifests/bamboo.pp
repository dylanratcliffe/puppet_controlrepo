class profile::bamboo {
  class { 'bamboo':
    username          => 'bamboo',
    pass_hash         => sha1('D#yQZtGenUZQmvzEKTzYk3VdENZh*AKXtioTgk^tVZ9GR)AyNA'),
    bamboo_version    => '5.9.7',
    bamboo_home       => '/opt/atlassian/bamboo',
    bamboo_data       => '/var/atlassian/application-data/bamboo',
    db_manage         => true,
    db_type           => 'postgresql',
    db_name           => 'bamboo_db',
    db_user           => 'bamboo',
    db_pass           => 'y&d{EKd3&9JTqxVGZAhvkNuhXBr#UetWaKthozbxAKWTMFtrqb',
    java_manage       => true,
    java_distribution => 'jdk',
    service_manage    => true,
    service_ensure    => 'running',
    service_enable    => true,
  }
}