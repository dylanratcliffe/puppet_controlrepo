class profile::metrics::dashboard (
  $apache_default_vhost = false,
  $carbon_port          = 7777,
  $grafana_host         = $::fqdn,
  $grafana_apache_port  = 80,
  $graphite_apache_port = 7000,
  $graphite_host        = $::fqdn,
){
  firewall { '100 allow http access':
    dport  => 80,
    proto  => 'tcp',
    action => 'accept',
  }

  firewall { '100 allow graphite and carbon access':
    dport  => [7777, 7000, 2003, 2004],
    proto  => 'tcp',
    action => 'accept',
  }

  class { 'apache':
    default_vhost => $apache_default_vhost,
  }

  class { 'apache::mod::wsgi':
    wsgi_socket_prefix => '/var/run/wsgi',
  }

  class { 'graphite':
    gr_web_server                => 'none',
    gr_aggregator_max_intervals  => 60,
    gr_storage_schemas           => [
      {
        'name'       => 'carbon',
        'pattern'    => '^carbon\.',
        'retentions' => '1m:90d'
      },
      {
        'name'       => 'default',
        'pattern'    => '.*',
        'retentions' => '10s:14d'
      }],
    gr_storage_aggregation_rules => {
      '00_min'         => {
        'pattern' => '\.min$',
        'factor'  => '0.5',
        'method'  => 'min'
      },
      '01_max'         => {
        'pattern' => '\.max$',
        'factor'  => '0.5',
        'method'  => 'max'
      },
      '02_sum'         => {
        'pattern' => '\.count$',
        'factor'  => '0.5',
        'method'  => 'sum'
      },
      '99_default_avg' => {
        'pattern' => '.*',
        'factor'  => '0.5',
        'method'  => 'average'
      }
    }
  }

  apache::vhost { 'graphite':
    servername                  => $graphite_host,
    port                        => $graphite_apache_port,
    docroot                     => '/opt/graphite/webapp',
    error_log_file              => 'graphite-error.log',
    access_log_file             => 'graphite-access.log',
    wsgi_script_aliases         => {
      '/' => '/opt/graphite/conf/graphite.wsgi'},
    wsgi_import_script          => '/opt/graphite/conf/graphite.wsgi',
    wsgi_import_script_options  => {
      'process-group'     => 'graphite',
      'application-group' => '%{GLOBAL}'},
    wsgi_daemon_process         => 'graphite',
    wsgi_daemon_process_options => {
      'processes'          => '5',
      'threads'            => '5',
      'display-name'       => '%{GROUP}',
      'inactivity-timeout' => '120'},
    wsgi_process_group          => 'graphite',
    wsgi_application_group      => '%{GLOBAL}',
    headers                     => [
      'set Access-Control-Allow-Origin "*"',
      'set Access-Control-Allow-Methods "GET, OPTIONS, POST"',
      'set Access-Control-Allow-Headers "origin, authorization, accept"'],
    directories                 => [{
      'path'  => '/opt/graphite/conf/',
      'order' => 'deny,allow' }],
    aliases                     => [
      {
        'alias' => '/content/',
        'path'  => '/opt/graphite/webapp/content/'
      },
      {
        'alias' => '/media/',
        'path'  => '@DJANGO_me@/contrib/admin/media/'
      }],
    custom_fragment             => @(END)
      <Location / >
      AuthType None
      Require all granted
      Satisfy Any
      </location>
      <Location /content/ >
      SetHandler None
      </Location>
      <Location /media/ >
      SetHandler None
      </Location>
      | END
  }

  class { 'grafana':
    graphite_host => $graphite_host,
    graphite_port => $graphite_apache_port,
  }

  profile::grafana::dashboard { 'master.methodologies.com':
    metrics_server_id => 'puppetmaster',
  }

  apache::vhost { 'grafana':
    servername      => $grafana_host,
    port            => $grafana_apache_port,
    docroot         => '/opt/grafana',
    error_log_file  => 'grafana-error.log',
    access_log_file => 'grafana-access.log',
    directories     => [
      {
        path           => '/opt/grafana',
        options        => [ 'None' ],
        allow          => 'from All',
        allow_override => [ 'None' ],
        order          => 'Allow,Deny',
      }
      ],
      require       => Class['grafana'],
  }

  file { 'default_dashboard':
    ensure  => file,
    path    => '/opt/grafana/app/dashboards/default.json',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('profile/dashboard.json.epp',{
      'server_id'   => $puppet_enterprise::profile::master::metrics_server_id,
      'collectd_id' => regsubst($::fqdn,'\.','_','G')
    })
  }
  notify { $server_facts['environment']: }

}
