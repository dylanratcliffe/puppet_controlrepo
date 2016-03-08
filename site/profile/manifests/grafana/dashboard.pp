define profile::grafana::dashboard (
  $metrics_server_id,
) {
  file { "/opt/grafana/app/dashboards/${title}.json":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0664',
    content => epp('profile/dashboard.json.epp'),
  }
}
