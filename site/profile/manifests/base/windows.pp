#
class profile::base::windows {
  stage { 'pre-run':
    before => Stage['main'],
  }

  class { 'chocolatey':
    stage => 'main',
  }

  $packages = [
    'atom',
    'putty',
    'googlechrome',
    '7zip.install',
    'powershell',
  ]

  package { $packages:
    ensure => 'latest',
  }
}
