class profile::base {
  include ::epel
  include ::systemd
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

  package { $packages:
    ensure => latest,
  }

  host { $::fqdn:
    ensure       => present,
    host_aliases => [$::hostname],
    ip           => $::ipaddress,
  }

  # Make sure that we install git before we try to use it
  Package['git'] -> Vcsrepo <| provider == 'git' |>
  Class['::epel'] -> Package <| |>
}
