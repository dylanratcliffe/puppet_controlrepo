class role::puppetmaster::api {
  include profile::base
  include profile::hiera
  include profile::puppetmaster::api_auth
}
