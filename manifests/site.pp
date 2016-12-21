if $::kernel == 'windows' {
  Package {
    provider => 'chocolatey',
  }
}

node default {
  if $::role {
    include $::role
  } else {
    fail('This machine has no role')
  }
}
