class role::puppetmaster {
  include profile::base
  include profile::sumologic
  include profile::hiera
}
