class profile::base {
  include ::epel

  package { ['tree','vim','git','htop']:
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
