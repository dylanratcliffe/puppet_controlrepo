#
class profile::windows_webserver {
  $install_dir    = 'C:/inetpub/sunburst'
  #$defaultwebsitepath = 'C:\inetpub\wwwroot'

  File {
    owner => 'Administrator',
    group => 'Administrators',
  }

  # Install the IIS role
  dsc_windowsfeature { 'IIS':
    dsc_ensure => 'present',
    dsc_name   => 'Web-Server',
  }

  # Install the ASP .NET 4.5 role
  dsc_windowsfeature { 'AspNet45':
    dsc_ensure => 'present',
    dsc_name   => 'Web-Asp-Net45',
  }

  # Stop an existing website (set up in Sample_xWebsite_Default)
  dsc_xwebsite { 'Stop DefaultSite':
    dsc_ensure       => 'present',
    dsc_name         => 'Default Web Site',
    dsc_state        => 'Stopped',
    #dsc_physicalpath => $defaultwebsitepath,
    require          => Dsc_windowsfeature['IIS','AspNet45'],
  }

  # Create a new website
  dsc_xwebsite { 'Sunburst':
    dsc_ensure       => 'present',
    dsc_name         => 'sunburst',
    dsc_state        => 'Started',
    dsc_physicalpath => $install_dir,
    require          => Dsc_windowsfeature['IIS','AspNet45'],
  }

  file { $install_dir:
    ensure => directory,
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
}
