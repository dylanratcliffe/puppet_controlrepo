# # Sunburst Webserver
#
# Runs a basic "sunburst" application
#
# **OS:** RedHat
#
class role::sunburst_webserver {
  include ::profile::base
  include ::profile::sunburst_app
}
