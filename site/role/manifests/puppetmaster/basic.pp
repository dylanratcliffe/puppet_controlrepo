class role::puppetmaster::basic {
  include profile::base
  include profile::puppetmaster
  include profile::metrics::collectd
  include profile::puppetmaster::autosign
}
