class profile::sunburst_app {
  $install_dir = lookup('profile::sunburst_app::install_dir',{'default_value'=> '/var/sunburst'})

  file { $install_dir:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { "${install_dir}/index.html":
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'http://bl.ocks.org/mbostock/raw/4348373/index.html',
  }

  file_line { 'json_source':
    path    => "${install_dir}/index.html",
    line    => 'd3.json("/flare.json", function(error, root) {',
    match   => '^d3.json\(.*, function\(error, root\) {$',
    require => File["${install_dir}/index.html"],
  }

  file { "${install_dir}/flare.json":
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'http://bl.ocks.org/mbostock/raw/4063550/flare.json',
  }

  include profile::nginx

  nginx::resource::server { $::fqdn:
    www_root => $install_dir,
  }

  firewall { '100 allow http':
    dport  => 80,
    proto  => tcp,
    action => accept,
  }
}
