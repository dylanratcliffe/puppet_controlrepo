# == Class: profile::eyeunify::ctrl
#
class profile::eyeunify::ctrl (
  String $source = 'https://eyeunify.org/wp_root/wp-content/uploads/2016/11/eyeUNIFYctrl_1_2_74261798.zip',
) {
  include ::profile::eyeunify::base

  # Actually deploy the core
  archive { 'eyeunify_ctrl.zip':
    path         => '/tmp/eyeunify_ctrl.zip',
    source       => $source,
    extract      => true,
    extract_path => '/tmp',
    creates      => '/tmp/eyeUNIFYctrl_1_2_74261798.war',
    cleanup      => true,
    user         => $wildfly::user,
    group        => $wildfly::user,
    require      => Package['unzip'],
    before       => Wildfly::Deployment['eyeunify_ctrl.war'],
  }

  wildfly::deployment { 'eyeunify_ctrl.war':
    source  => 'file:///tmp/eyeUNIFYctrl_1_2_74261798.war',
    require => Class['profile::eyeunify::core::database_connection'],
  }

  # Also add a reverse proxy
  include ::profile::nginx

  nginx::resource::server { $::facts['fqdn']:
    listen_port => 80,
    proxy       => 'http://localhost:8080',
  }

  @@haproxy::balancermember { "${facts['fqdn']}-eyeunify":
    listening_service => 'eyeunify',
    ports             => '80',
    server_names      => $facts['fqdn'],
    ipaddresses       => $facts['networking']['ip'],
    options           => 'check',
  }
}
