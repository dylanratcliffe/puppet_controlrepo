class profile::cd4pe (
  String $cd4pe_version                  = 'latest',
  String $network_name                   = 'cd4pe-network',
  Sensitive[String] $mysql_root_password = Sensitive(fqdn_rand_string(20)),
  Sensitive[String] $mysql_password      = Sensitive(fqdn_rand_string(20)),
  Sensitive[String] $cd4pe_db_password   = Sensitive(fqdn_rand_string(20)),
) {
  include profile::docker

  class { 'profile::cd4pe::artifactory':
    network_name => $network_name,
  }

  # Set this default because there seems to be a bug in puppetlabs/docker 3.0.0
  # that makes it effectively required.
  Docker::Run {
    health_check_interval => 30,
  }

  ['3306', '7000', '8000', '8080', '8081'].each |$port| {
    firewall { "100 allow cd4pe ${port}":
      proto  => 'tcp',
      dport  => $port,
      action => 'accept',
    }
  }

  docker::image { 'mysql':
    image_tag => '5.7',
  }

  docker::image { 'puppet/continuous-delivery-for-puppet-enterprise':
    image_tag => $cd4pe_version,
  }

  docker_network { $network_name:
    ensure      => 'present',
    driver      => 'bridge',
    ipam_driver => 'default',
    subnet      => '172.18.0.0/16',
  }

  docker::run { 'cd4pe-mysql':
    image   => 'mysql:5.7',
    net     => $network_name,
    ports   => ['3306:3306'],
    volumes => ['cd4pe-mysql:/var/lib/mysql'],
    env     => [
      "MYSQL_ROOT_PASSWORD=${mysql_root_password}",
      'MYSQL_DATABASE=cd4pe',
      "MYSQL_PASSWORD=${mysql_password}",
      'MYSQL_USER=cd4pe',
    ],
  }

  docker::run { 'cd4pe':
    image   => "puppet/continuous-delivery-for-puppet-enterprise:${cd4pe_version}",
    net     => $network_name,
    ports   => ['8080:8080', '8000:8000', '7000:7000'],
    volumes => [
      'cd4pe-mysql:/var/lib/mysql',
      '/etc/hosts:/etc/hosts',
    ],
    env     => [
      'DB_ENDPOINT=mysql://cd4pe-mysql:3306/cd4pe',
      'DB_USER=cd4pe',
      "DB_PASS=${cd4pe_db_password}",
      'DUMP_URI=dump://localhost:7000',
      'PFI_SECRET_KEY=CapsQQCKq+hdYYWS+DhIpw==',
    ],
  }
}
