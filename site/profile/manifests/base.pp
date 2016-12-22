#
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
    'zlib',
    'zlib-devel',
    'jq',
  ]

  package { $packages:
    ensure => latest,
  }

  include ::rvm

  rvm_system_ruby { 'ruby-2.3.3':
    ensure      => 'present',
    default_use => true,
  }

  package { 'bundler':
    ensure   => present,
    provider => 'gem',
    require  => Rvm_system_ruby['ruby-2.3.3'],
  }

  class { 'selinux':
    mode => 'permissive',
    type => 'targeted',
  }

  # Make sure that we install git before we try to use it
  Package['git'] -> Vcsrepo <| provider == 'git' |>
}
