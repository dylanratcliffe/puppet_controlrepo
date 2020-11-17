# Manages a DNS server
class profile::dns::server {
  class { 'bind':
    forwarders => [
        '8.8.8.8',
        '8.8.4.4',
    ],
    dnssec     => false,
    version    => 'Controlled by Puppet',
  }

  # This key is just randomly generated. Not really a secret
  $local_secret = '+0VnhFp9T+N0EcaDluU8rDdWX1/ecVPhrZQ/yse997DkfgBg57Xo2TTEdjiYBHs1v/bk8RTLi92WY+r39Aw2YQ=='

  # Inject credentials
  Resource_record <| |> {
    keyname => 'local-update',
    hmac    => 'hmac-sha256',
    secret  => $local_secret,
  }

  bind::key { 'local-update':
    algorithm => 'hmac-sha256',
    secret    => $local_secret,
  }

  # Create a zone for the local domain
  bind::zone { 'puppet.local':
    zone_type     => 'master',
    domain        => 'puppet.local',
    allow_updates => [ 'key local-update' ],
  }

  bind::view { 'local':
    recursion => true,
    zones     => [
      'puppet.local',
    ],
  }

  resource_record { 'foo.puppet.local':
    ensure  => present,
    record  => 'foo.puppet.local',
    type    => 'A',
    zone    => 'puppet.local',
    data    => [
      '10.0.0.10',
    ],
  }

  # Collect exported records
  Resource_record <<| zone == 'puppet.local' |>>

  # if $facts['networking']['domain'] {
  #     # Create a zone for the local domain
  #     bind::zone { $facts['networking']['domain']:
  #       zone_type     => 'master',
  #       domain        => $facts['networking']['domain'],
  #       allow_updates => [ 'key local-update' ],
  #     }

  #     # Collect exported records
  #     Resource_record <<| zone == $facts['networking']['domain'] |>>
  # }
}
