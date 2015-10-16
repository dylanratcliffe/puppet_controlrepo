class profile::sumologic {
  $sumologic_key = hiera('profile::sumologic::sumologic_key')

  # This data is completely made up, it will not work
  class { '::sumologic::report_handler':
    report_url => "https://collectors.au.sumologic.com/receiver/v1/http/${sumologic_key}",
    mode       => 'stdout',
  }
}
