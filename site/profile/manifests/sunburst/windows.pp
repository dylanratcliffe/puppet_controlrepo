# == Class: profile::sunburst::windows
#
class profile::sunburst::windows (
  String $install_dir = 'C:/inetpub/sunburst',
  String $user        = 'sunburst',
  String $group       = 'sunburst-admins',
  String $password    = 'change3me',
) {
  require ::profile::windows::webserver

  user { $user:
    ensure  => present,
    comment => 'Sunburst Application Service Account',
    gid     => $group,
  }

  group { $group:
    ensure => present,
  }

  iis_application_pool { 'sunburst':
    ensure        => present,
    state         => 'started',
    identity_type => 'SpecificUser',
    user_name     => $user,
    password      => $password,
  }

  # Create a new website
  iis_site { 'sunburst':
    ensure          => 'started',
    physicalpath    => 'C:\\inetpub\\sunburst',
    applicationpool => 'sunburst',
    require         => [Iis_application_pool['sunburst'], Dsc_windowsfeature['IIS','AspNet45']],
  }

  file { $install_dir:
    ensure => directory,
  }

  acl { $install_dir:
    inherit_parent_permissions => false,
    purge                      => true,
    owner                      => $user,
    group                      => $group,
    permissions                => [
      {
        'affects'  => 'all',
        'identity' => 'NT AUTHORITY\SYSTEM',
        'rights'   => ['full'],
      },
      {
        'affects'  => 'all',
        'identity' => 'BUILTIN\Administrators',
        'rights'   => ['full'],
      },
      {
        'affects'  => 'all',
        'identity' => "BUILTIN\\${user}",
        'rights'   => ['full'],
      },
      {
        'affects'  => 'all',
        'identity' => "BUILTIN\\${group}",
        'rights'   => ['read', 'execute'],
      },
    ],
    require                    => File[$install_dir],
  }

  file { "${install_dir}/index.html":
    ensure => file,
    mode   => '0644',
    source => 'https://bl.ocks.org/mbostock/raw/4348373/index.html',
  }

  file_line { 'json_source':
    path    => "${install_dir}/index.html",
    line    => 'd3.json("/flare.json", function(error, root) {',
    match   => '^d3.json\(.*, function\(error, root\) {$',
    require => File["${install_dir}/index.html"],
  }

  file { "${install_dir}/flare.json":
    ensure => file,
    mode   => '0644',
    source => 'https://bl.ocks.org/mbostock/raw/4348373/flare.json',
  }
}
