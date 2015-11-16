class profile::vagrant {
  $version = '1.7.4'

  file { ['/opt/vagrant','/opt/vagrant/packages']:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  archive::download { "vagrant_${version}_x86_64.rpm":
    url        => "https://dl.bintray.com/mitchellh/vagrant/vagrant_${version}_x86_64.rpm",
    src_target => '/opt/vagrant/packages',
    checksum   => false,
    require    => File['/opt/vagrant/packages'],
  }

  class { '::vagrant':
    version => $version,
    source  => "/opt/vagrant/packages/vagrant_${version}_x86_64.rpm",
    require => Archive::Download["vagrant_${version}_x86_64.rpm"],
  }
}