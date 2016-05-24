#
class profile::hubot {
  include ::nodejs

  package { 'hubot-slack':
    ensure   => 'latest',
    provider => 'npm',
    require  => Class['::nodejs'],
  }

  class { '::hubot':
    bot_name     => 'pinaldave',
    display_name => 'pinaldave',
    #build_deps  => 'hubot-slack',
    env_export   => '',
    scripts      => [], #hubot scripts to use
    adapter      => 'slack',
    require      => [Class['nodejs'],Package['hubot-slack']],
  }
}
