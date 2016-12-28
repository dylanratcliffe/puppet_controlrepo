# == Class: role::sunburst_webserver
#
class role::sunburst_webserver {
  include profile::base
  include profile::sunburst_app
}
