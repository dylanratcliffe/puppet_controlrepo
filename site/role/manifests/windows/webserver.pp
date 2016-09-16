#
class role::windows::webserver {
  include profile::base::windows
  include profile::windows_webserver
}
