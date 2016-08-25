class profile::base {
  if $::os['family'] == 'RedHat' {
    include ::epel
    include ::systemd

    # Make sure that systemd picks up any new services that we install
    # Package <||> ~> Exec['systemctl-daemon-reload'] -> Service <||>
    Class['::epel'] -> Package <||>
  }

  include ::gcc

  $packages = [
    'tree',
    'vim',
    'git',
    'htop',
    'ruby',
    'ruby-devel',
    'zlib',
    'zlib-devel'
  ]

  package lasjdf lasn dfkja skdjfh aksjdf  { $packages:
    ensure => latest,
  }

  host { $::fqdn:
    ensure       => present,
    host_aliases => [$::hostname],
    ip           => $::ipaddress,
  }

  # Make sure that we install git before we try to use it
  Package['git'] -> Vcsrepo <| provider == 'git' |>
}
