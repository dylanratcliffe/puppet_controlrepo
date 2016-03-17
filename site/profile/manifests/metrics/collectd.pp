class profile::metrics::collectd {

  class { '::collectd':
    purge_config => true,
    interval     => '5',
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
