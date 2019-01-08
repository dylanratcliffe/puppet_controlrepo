class profile::cd4pe::artifactory (
  String $artifactory_version = 'latest',
  String $network_name        = 'cd4pe-network',
  String $bootstrap_dir       = '/etc/artifactory_bootstrap',
) {
  Docker::Run {
    health_check_interval => 30,
  }

  # Create the volume and insert bootstrap data
  docker_volume { 'data_s3':
    ensure => present,
  }

  file { $bootstrap_dir:
    ensure => directory
  }

  file { "${bootstrap_dir}/artifactory.config.import.xml":
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
    source => 'puppet:///modules/profile/artifactory/config_descriptor.xml',
  }

  file { "${bootstrap_dir}/security.import.xml":
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
    source => 'puppet:///modules/profile/artifactory/security_descriptor.xml',
  }

  # Start a quick alpine container to copt files around
  $docker_command_prefix = "docker run --rm -v ${bootstrap_dir}:/source -v data_s3:/dest -w /source alpine"

  exec { 'create /etc inside data_s3':
    command     => "${docker_command_prefix} mkdir -p /dest/etc",
    path        => $facts['path'],
    refreshonly => true,
    require     => Docker_volume['data_s3'],
    subscribe   => File["${bootstrap_dir}/artifactory.config.import.xml"],
  }

  ['artifactory.config.import.xml', 'security.import.xml'].each |$file| {
    exec { "move ${file} into data_s3":
      command     => "${docker_command_prefix} cp /source/${file} /dest/etc/${file}",
      path        => $facts['path'],
      refreshonly => true,
      require     => Exec['create /etc inside data_s3'],
      subscribe   => File["${bootstrap_dir}/artifactory.config.import.xml"],
    }
  }

  exec { 'set permissions':
    command     => "${docker_command_prefix} chown -R 1030:1030 /dest",
    path        => $facts['path'],
    refreshonly => true,
    subscribe   => File["${bootstrap_dir}/artifactory.config.import.xml","${bootstrap_dir}/security.import.xml"],
  }

  docker::image { 'docker.bintray.io/jfrog/artifactory-oss':
    image_tag => $artifactory_version,
  }

  docker::run { 'cd4pe-artifactory':
    image   => "docker.bintray.io/jfrog/artifactory-oss:${artifactory_version}",
    net     => $network_name,
    ports   => ['8081:8081'],
    volumes => ['data_s3:/var/opt/jfrog/artifactory'],
  }

}
