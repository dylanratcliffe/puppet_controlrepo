class role::jenkins {
  include ::profile::base
  include ::profile::rvm
  include ::profile::metrics::collectd
  include ::profile::jenkins
}
