class role::jenkins {
  include profile::base
  include profile::metrics::collectd
  include profile::jenkins
}
