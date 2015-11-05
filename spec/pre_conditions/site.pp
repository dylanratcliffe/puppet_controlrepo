# We are not going to actually have this service anywhere on our servers but
# our code needs to refresh it. This is to trck puppet into doing nothing
service { 'pe-puppetserver':
  ensure     => 'running',
  enable     => false,
  hasrestart => false, # Force Puppet to use start and stop to restart
  start      => 'ls', # This will always work
  stop       => 'ls', # This will also always work
  hasstatus  => false, # Force puppet to use our command for status
  status     => 'ls' # This will always exit 0 and therefor Puppet will think the service is running
}

