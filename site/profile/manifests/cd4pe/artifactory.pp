class profile::cd4pe::artifactory (
  String $artifactory_version = 'latest',
  String $network_name        = 'cd4pe-network',
  String $bootstrap_dir       = '/etc/artifactory_bootstrap',
) {
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

  exec { 'move config_descriptor into volume':
    command     => "docker cp ${bootstrap_dir}/artifactory.config.import.xml data_s3:/etc/artifactory.config.import.xml",
    path        => $facts['path'],
    refreshonly => true,
    require     => Docker_volume['data_s3'],
    subscribe   => File["${bootstrap_dir}/artifactory.config.import.xml"],
  }

  file { "${bootstrap_dir}/security.import.xml":
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
    source => 'puppet:///modules/profile/artifactory/security_descriptor.xml',
  }

  exec { 'move security_descriptor into volume':
    command     => "docker cp ${bootstrap_dir}/security.import.xml data_s3:/etc/security.import.xml",
    path        => $facts['path'],
    refreshonly => true,
    require     => Docker_volume['data_s3'],
    subscribe   => File["${bootstrap_dir}/security.import.xml"],
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
