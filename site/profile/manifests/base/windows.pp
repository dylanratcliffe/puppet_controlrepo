#
class profile::base::windows (
  Boolean $noop = false,
) {
  noop($noop)

  include ::profile::base::windows::hardening

  stage { 'pre-run':
    before => Stage['main'],
  }

  class { '::chocolatey':
    stage => 'pre-run',
  }

  service { 'wuauserv':
    ensure => 'running',
    enable => true,
  }

  file { 'C:\app':
    ensure => 'directory',
  }

  # Set detailed permissions on the app directory
  acl { 'C:\app':
    group                      => 'Administrators',
    inherit_parent_permissions => false,
    purge                      => true,
    owner                      => 'Administrator',
    permissions                => [
      {
        'affects'  => 'self_only',
        'identity' => 'NT AUTHORITY\SYSTEM',
        'rights'   => ['full']
      },
      {
        'affects'  => 'self_only',
        'identity' => 'BUILTIN\Administrators',
        'rights'   => ['full']
      },
      {
        'affects'  => 'self_only',
        'identity' => 'BUILTIN\Users',
        'rights'   => ['read', 'execute']
      }
    ],
    require                    => File['C:\app'],
  }

  $packages = [
    'atom',
    '7zip.install',
    'carbon',
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
