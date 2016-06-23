class profile::base {
  if $::os['family'] == 'RedHat' {
    include ::epel
    include ::systemd

    if $::ec2_metadata {
      # Also enable the optional repo which is disabled in AWS
      yumrepo { 'rhui-REGION-rhel-server-optional':
        ensure  => 'present',
        enabled => '1',
        before  => Package['ruby-devel'],
      }
    }

    # Make sure that systemd picks up any new services that we install
    Package <||> ~> Exec['systemctl-daemon-reload'] -> Service <||>
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

  package { $packages:
    ensure => latest,
  }

  host { $::fqdn:
    ensure       => present,
    host_aliases => [$::hostname],
    ip           => $::ipaddress,
    parameter    => 'value',
  }

  # Make sure that we install git before we try to use it
  Package['git'] -> Vcsrepo <| provider == 'git' |>
}
