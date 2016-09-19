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
  ]

  package { $packages:
    ensure   => 'latest',
    provider => 'chocolatey',
  }

  package { 'putty.install':
    ensure          => present,
    install_options => '--allow-empty-checksums',
  }

  package { 'powershell':
    ensure  => present,
    require => Service['wuauserv'],
    notify  => Reboot['immediately'],
  }

  reboot { 'immediately':
    apply => 'immediately',
  }
}
