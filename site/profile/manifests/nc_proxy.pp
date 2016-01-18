class profile::nc_proxy {
  package { 'puppetclassify-gem':
    ensure   => latest,
    name     => 'puppetclassify',
    provider => 'gem',
  }

  package { 'puppetclassify-puppet_gem':
    ensure   => latest,
    name     => 'puppetclassify',
    provider => 'puppet_gem',
  }



}