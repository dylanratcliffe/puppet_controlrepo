class role::puppetmaster::basic {
  include ::profile::base
  include ::profile::puppetmaster
  include ::profile::metrics::collectd
  include ::profile::puppetmaster::autosign
  include ::pe_repo::platform::windows_i386
  include ::pe_repo::platform::windows_x86_64
  include ::pe_repo::platform::el_6_x86_64
  include ::profile::file_sync::master_patch
  include ::profile::dns::server
}
