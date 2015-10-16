class role::puppetmaster {
  include profile::sumologic
  include profile::hiera
}
