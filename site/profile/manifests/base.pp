#
class profile::base {
  if $::os['family'] == 'RedHat' {
    include ::epel
    include ::systemd

    # Make sure that systemd picks up any new services that we install
    # Package <||> ~> Exec['systemctl-daemon-reload'] -> Service <||>
    Class['::epel'] -> Package <||>
  }

  # Comments go here
  asdfhjb asjdhf kjasd f ajksdf kjashbdf
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
  ]

  package { $packages:
    ensure => latest,
  }

  class { 'selinux':
    mode => 'disabled',
    type => 'minimum',
  }

  # Make sure that we install git before we try to use it
  Package['git'] -> Vcsrepo <| provider == 'git' |>

  file { '/etc/puppetlabs/puppet/csr_attributes.yaml':
    ensure => absent,
  }
}
