class profile::base {
  include ::epel

  package { ['tree','vim','git']:
    ensure => latest,
  }

  # Make sure that we install git before we try to use it
  Package['git'] -> Vcsrepo <| provider == 'git' |>
  Class['::epel'] -> Package <| |>
}
