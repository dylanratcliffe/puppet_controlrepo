class profile::metrics::collectd {
  $collectd_dir = '/etc/collectd'

  # We need this repo because it has the latest version of collectd
  # other ones only have version 4 which does not support graphite
  # yumrepo { 'dag_testing_packages':
  #   ensure   => present,
  #   enabled  => '1',
  #   gpgcheck => '0',
  #   baseurl  => 'ftp://fr2.rpmfind.net/linux/dag/redhat/el6/en/$basearch/testing',
  # }

  # Do this yumrepo before ANY packages
  #Yumrepo['dag_testing_packages'] -> Package <||>

  #require profile::metrics::collectd::compile


  class { '::collectd':
    purge_config     => true,
  }

  include ::collectd::plugin::cpu
  include ::collectd::plugin::disk
  include ::collectd::plugin::memory
  include ::collectd::plugin::interface
  include ::collectd::plugin::df

  collectd::plugin::write_graphite::carbon {'my_graphite':
    graphitehost   => 'metrics.methodologies.com',
    graphiteport   => 2003,
    graphiteprefix => '',
    protocol       => 'tcp'
  }

}
