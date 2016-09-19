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
    enable => true,
  }

  $packages = [
    'atom',
    'googlechrome',
    '7zip.install',
  ]

  package { $packages:
    ensure   => 'latest',
  }

  package { 'putty.install':
    ensure          => present,
    install_options => '--allow-empty-checksums',
  }

  package { 'powershell':
    ensure          => present,
    install_options => '--ignore-package-exit-codes',
    require         => Service['wuauserv'],
    notify          => Reboot['immediately'],
  }

  reboot { 'immediately':
    apply   => 'immediately',
    timeout => '0',
  }
}
