if $::kernel == 'windows' {
  Package {
    provider => 'chocolatey',
  }
}

node default {
  if $::role {
    include $::role
  }
}
