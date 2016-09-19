if $::kernel == 'windows' {
  Package {
    provider => 'chocolatey',
  }
}

node default {
  include $::role
}
