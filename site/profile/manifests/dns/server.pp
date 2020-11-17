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

  bind::key { 'local-update':
    secret_bits => 512,
  }

  # Create a zone for the local domain
  bind::zone { 'puppet.local':
    zone_type     => 'master',
    domain        => 'puppet.local',
    allow_updates => [ 'key local-update' ],
  }

  # Collect exported records
  Resource_record <<| zone == 'puppet.local' |>>

  if $facts['networking']['domain'] {
      # Create a zone for the local domain
      bind::zone { $facts['networking']['domain']:
        zone_type     => 'master',
        domain        => $facts['networking']['domain'],
        allow_updates => [ 'key local-update' ],
      }

      # Collect exported records
      Resource_record <<| zone == $facts['networking']['domain'] |>>
  }
}
