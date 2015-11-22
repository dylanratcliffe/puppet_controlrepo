class role::dbserver {
  if $::os['family'] == 'Debian' { include profile::apt }
  include profile::base
  include profile::mysql_server
}
