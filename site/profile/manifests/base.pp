class profile::base {
  package { ['tree','vim']:
    ensure => latest,
  }
}