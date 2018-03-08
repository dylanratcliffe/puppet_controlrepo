# Creates the metrics dashboard
class profile::metrics::dashboard (
  Array $master_list = [$server_facts['servername']],
) {
  class { 'pe_metrics_dashboard':
    add_dashboard_examples => true,
    consume_graphite       => true,
    influxdb_database_name => ["graphite"],
    master_list            => $master_list,
    overwrite_dashboards   => false,
  }
}
