class profile::puppetmaster::autosign {
  file { '/etc/puppetlabs/puppet/autosign':
    ensure => directory,
    owner  => 'pe-puppet',
    group  => 'pe-puppet',
    mode   => '0700',
  }

  file { '/etc/puppetlabs/puppet/autosign/autosign.sh':
    ensure => file,
    owner  => 'pe-puppet',
    group  => 'pe-puppet',
    mode   => '0700',
    source => 'puppet:///modules/profile/autosign.sh'
  }

  ini_setting { 'policy_based_autosigning':
    ensure  => present,
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    section => 'master',
    setting => 'autosign',
    value   => '/etc/puppetlabs/puppet/autosign/autosign.sh',
    notify  => Service['pe-puppetserver'],
  }
}
