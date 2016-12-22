class profile::metrics::dashboard {
  $carbon_port          = 7777
  $grafana_host         = $::fqdn
  $graphite_host        = $::fqdn
  $graphite_port        = 7000

  firewall { '100 allow http access':
    dport  => 80,
    proto  => 'tcp',
    action => 'accept',
  }

  firewall { '100 allow graphite and carbon access':
    dport  => [7777, $graphite_port, 2003, 2004],
    proto  => 'tcp',
    action => 'accept',
  }

  class { 'apache':
    default_vhost => false,
  }

  class { 'apache::mod::wsgi':
    wsgi_socket_prefix => '/var/run/wsgi',
  }

  class { 'graphite':
    gr_web_server                => 'none',
    gr_web_group                 => 'apache',
    gr_web_user                  => 'apache',
    gr_group                     => 'apache',
    gr_user                      => 'apache',
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
    port                        => $graphite_port,
    docroot                     => '/opt/graphite/webapp',
    error_log_file              => 'graphite-error.log',
    access_log_file             => 'graphite-access.log',
    wsgi_script_aliases         => {
      '/' => '/opt/graphite/conf/graphite_wsgi.py'},
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

  # Relly ugly hack to test issue in graphite module
  Package <| provider == 'pip' |> {
    require +> Package['python-pip']
  }

  # include ::docker
  class { '::grafana':
    graphite_host => $::networking['ip'],
    graphite_port => $graphite_port,
  }

  # nginx::resource::vhost { 'grafana':
  #   listen_port => '80',
  #   www_root    => '/opt/grafana',
  # }

  apache::vhost { 'grafana':
    servername      => $grafana_host,
    port            => '80',
    docroot         => '/opt/grafana',
    manage_docroot  => false,
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
    require         => Class['grafana'],
  }


  file { 'default_dashboard':
    ensure  => file,
    path    => '/opt/grafana/app/dashboards/default.json',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp('profile/dashboard.json.epp',{
      'server_id'   => regsubst($servername,'\..*',''), # Could get this from hiera
      'collectd_id' => regsubst($servername,'\.','_','G'),
    })
  }

}
