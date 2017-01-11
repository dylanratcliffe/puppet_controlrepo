class role::puppetmaster::api {
  include profile::base
  include profile::puppetmaster
  include profile::puppetmaster::api_auth
  include profile::puppetmaster::autosign
}
