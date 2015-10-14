class profile::sumologic {
  $sumologic_key = hiera('profile::sumologic::sumologic_key')

  # This data is completely made up, it will not work
  class { '::sumologic::report_handler':
    report_url => "https://collector.sumologic.test/?code=${sumologic_key}",
    mode       => 'json',
  }
}
