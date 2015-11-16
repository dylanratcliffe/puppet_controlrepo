class profile::vagrant {
  $version = '1.7.4'

  file { ['/opt/vagrant','/opt/vagrant/packages']:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  include ::archive

  archive { "/opt/vagrant/packages/vagrant_${version}_x86_64.rpm":
    ensure  => present,
    source  => "https://dl.bintray.com/mitchellh/vagrant/vagrant_${version}_x86_64.rpm",
    require => [File['/opt/vagrant/packages'],Class['::archive']],
  }

  class { '::vagrant':
    version => $version,
    source  => "/opt/vagrant/packages/vagrant_${version}_x86_64.rpm",
  }
}