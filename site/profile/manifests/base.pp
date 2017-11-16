#
class profile::base {
  if $::os['family'] == 'RedHat' {
    stage { 'repos':
      before => Stage['main'],
    }

    class { '::epel':
      stage => 'repos',
    }

    include ::systemd
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
    'unzip',
  ]

  package { $packages:
    ensure => latest,
  }

  class { '::selinux':
    mode   => 'disabled',
    type   => 'minimum',
    notify => Reboot['after_run'],
  }

  reboot { 'after_run':
    apply  => finished,
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
