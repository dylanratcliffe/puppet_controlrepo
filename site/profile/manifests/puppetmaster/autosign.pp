class profile::puppetmaster::autosign (
  String $logfile     = '/var/log/puppetlabs/puppetserver/autosign.log',
  String $journalfile = '/etc/puppetlabs/puppetserver/autosign.journal',
) {
  class { '::autosign':
    ensure   => 'latest',
    settings => {
      'general'   => {
        'loglevel' => 'INFO',
        'logfile'  => $logfile,
      },
      'jwt_token' => {
        'secret'      => fqdn_rand_string(10),
        'validity'    => '7200',
        'journalfile' => $journalfile,
      }
    },
  }

  ini_setting {'policy-based autosigning':
    setting => 'autosign',
    path    => "${::settings::confdir}/puppet.conf",
    section => 'master',
    value   => '/opt/puppetlabs/puppet/bin/autosign-validator',
    notify  => Service['pe-puppetserver'],
    require => Class['::autosign'],
  }

  #
  #
  # file { '/etc/puppetlabs/puppet/autosign':
  #   ensure => directory,
  #   owner  => 'pe-puppet',
  #   group  => 'pe-puppet',
  #   mode   => '0700',
  # }
  #
  # file { '/etc/puppetlabs/puppet/autosign/autosign.sh':
  #   ensure => file,
  #   owner  => 'pe-puppet',
  #   group  => 'pe-puppet',
  #   mode   => '0700',
  #   source => 'puppet:///modules/profile/autosign.sh',
  # }
  #
  # ini_setting { 'policy_based_autosigning':
  #   ensure  => present,
  #   path    => '/etc/puppetlabs/puppet/puppet.conf',
  #   section => 'master',
  #   setting => 'autosign',
  #   value   => '/etc/puppetlabs/puppet/autosign/autosign.sh',
  #   notify  => Service['pe-puppetserver'],
  # }
}
