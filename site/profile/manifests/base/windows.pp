#
class profile::base::windows {
  stage { 'pre-run':
    before => Stage['main'],
  }

  class { 'chocolatey':
    stage => 'pre-run',
  }

  service { 'wuauserv':
    ensure => 'running',
    enable => 'true',
  }

  $packages = [
    'atom',
    'googlechrome',
    '7zip.install',
    'powershell',
  ]

  package { $packages:
    ensure   => 'latest',
    provider => 'chocolatey',
    require  => Service['wuauserv'],
  }

  package { 'putty.install':
    ensure          => present,
    install_options => '--allow-empty-checksums',
  }
}
