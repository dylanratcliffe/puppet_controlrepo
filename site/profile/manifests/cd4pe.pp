class profile::cd4pe (
  String $cd4pe_version = 'latest',
) {
  class { '::cd4pe':
    cd4pe_version        => $cd4pe_version,
    manage_database      => true,
    agent_service_port   => 7000,
    backend_service_port => 8000,
    web_ui_port          => 8080,
  }
}
