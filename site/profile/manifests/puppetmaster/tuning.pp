# == Class: profile::puppetmaster::tuning
#
class profile::puppetmaster::tuning {
  # How much memory to leave for the system
  $reserved_memory = 512

  # NOTE: This might be better in ruby
  # The best thing to do here is probably the following:
  # Take the total system memory
  $memory_mb = (($::memory['system']['total_bytes'] / 1024) / 1024)

  # Subtract some memory to leave for the system
  $available_memory = $memory_mb - $reserved_memory

  # Calculate the base memory for other puppet systems; activemq etc.
  $console_services_base_memory       = 256
  $orchestration_services_base_memory = 192
  $puppetdb_base_memory               = 256
  $activemq_base_memory               = 512

  # Calculate how much the puppetserver and jrubies are going to need
  $max_active_instances = $::processors['count']
  $puppetserver_optimal_memory = (512 + ($max_active_instances * 512))

  # Make sure that we are not overallocating memory
  $puppetserver_available_memory = ($memory_mb - $reserved_memory
                                    - $console_services_base_memory
                                    - $orchestration_services_base_memory
                                    - $puppetdb_base_memory
                                    - $activemq_base_memory)

  # if not, bump up the subsystem memory; activemq, puppetdb etc.
  if ($puppetserver_optimal_memory < $puppetserver_available_memory) {
    $puppetserver_memory = $puppetserver_optimal_memory
    # If we can afford to double the base memory of the other stuff, do it.
    if ((($console_services_base_memory +
    $orchestration_services_base_memory +
    $puppetdb_base_memory +
    $activemq_base_memory) * 2) +
    $puppetserver_optimal_memory) < $memory_mb {
      $console_services_memory       = $console_services_base_memory * 2
      $orchestration_services_memory = $orchestration_services_base_memory * 2
      $puppetdb_memory               = $puppetdb_base_memory * 2
      $activemq_memory               = $activemq_base_memory * 2
    } else {
      # Otherwise just leave them where they are
      $console_services_memory       = $console_services_base_memory
      $orchestration_services_memory = $orchestration_services_base_memory
      $puppetdb_memory               = $puppetdb_base_memory
      $activemq_memory               = $activemq_base_memory
    }
  } else {
    $puppetserver_memory           = $puppetserver_available_memory
    $console_services_memory       = $console_services_base_memory
    $orchestration_services_memory = $orchestration_services_base_memory
    $puppetdb_memory               = $puppetdb_base_memory
    $activemq_memory               = $activemq_base_memory
  }

  $pe_master_group       = node_groups('PE Master')
  $pe_console_group      = node_groups('PE Console')
  $pe_orchestrator_group = node_groups('PE Orchestrator')
  $pe_puppetdb_group     = node_groups('PE PuppetDB')
  $pe_activemq_group     = node_groups('PE ActiveMQ Broker')

  notify { "${pe_master_group}": }
  notify { "${pe_console_group}": }
  notify { "${pe_orchestrator_group}": }
  notify { "${pe_puppetdb_group}": }
  notify { "${pe_activemq_group}": }

  $pe_master_group_additions = {
    'classes' => {
      'puppet_enterprise::profile::master' => {
        'java_args' => "{\"Xmx\": \"${puppetserver_memory}m\", \"Xms\": \"${puppetserver_memory}m\"}"
      }
    }
  }

  # TODO: If we have bumped the subsystems to a high value and we still have memory left over *maybe* allocate the rest to puppetserver


}
