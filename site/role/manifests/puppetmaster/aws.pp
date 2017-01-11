class role::puppetmaster::aws {
  include profile::base
  include profile::puppetmaster
  include profile::puppetmaster::aws
  include profile::puppetmaster::autosign
}
