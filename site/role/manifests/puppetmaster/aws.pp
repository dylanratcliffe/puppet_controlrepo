class role::puppetmaster::aws {
  include profile::base
  include profile::hiera
  include profile::puppetmaster
  include profile::puppetmaster::aws
}
