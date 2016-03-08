class role::puppetmaster {
  include profile::base
  #include profile::sumologic
  include profile::metrics::collectd
  include profile::hiera
  include profile::puppetmaster
}
