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
    'ruby',
    'ruby-devel',
    'multitail',
    'haveged',
    'cmake',
    'tmux',
  ]

  package { $packages:
    ensure => latest,
  }

  class { 'selinux':
    mode => 'disabled',
    type => 'minimum',
  }

  # Use haveged for entropy generation
  service { 'haveged':
    ensure  => running,
    enable  => true,
    require => Package['haveged'],
  }

  # Make sure that we install git before we try to use it
  Package['git'] -> Vcsrepo <| provider == 'git' |>

  file { '/etc/puppetlabs/puppet/csr_attributes.yaml':
    ensure => absent,
  }
}
