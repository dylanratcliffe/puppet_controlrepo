class profile::jenkins {
  class { '::jenkins':
    version            => '2.60.1',
    service_enable     => false,
    configure_firewall => true,
    executors          => $::processors['count'],
  }

  $plugins = [
    'ace-editor',
    'authentication-tokens',
    'blueocean-autofavorite',
    'blueocean-commons',
    'blueocean-config',
    'blueocean-dashboard',
    'blueocean-display-url',
    'blueocean-events',
    'blueocean-github-pipeline',
    'blueocean-git-pipeline',
    'blueocean-i18n',
    'blueocean',
    'blueocean-jwt',
    'blueocean-personalization',
    'blueocean-pipeline-api-impl',
    'blueocean-pipeline-editor',
    'blueocean-pipeline-scm-api',
    'blueocean-rest-impl',
    'blueocean-rest',
    'blueocean-web',
    'bouncycastle-api',
    'branch-api',
    'cloudbees-folder',
    'credentials-binding',
    'display-url-api',
    'docker-commons',
    'docker-workflow',
    'durable-task',
    'favorite',
    'git-client',
    'github-api',
    'github-branch-source',
    'github',
    'git',
    'git-server',
    'icon-shim',
    'jackson2-api',
    'jquery-detached',
    'junit',
    'mailer',
    'matrix-project',
    'metrics',
    'pipeline-graph-analysis',
    'pipeline-input-step',
    'pipeline-model-api',
    'pipeline-model-declarative-agent',
    'pipeline-model-definition',
    'pipeline-model-extensions',
    'pipeline-stage-step',
    'pipeline-stage-tags-metadata',
    'plain-credentials',
    'pubsub-light',
    'puppet-enterprise-pipeline',
    'scm-api',
    'script-security',
    'sse-gateway',
    'ssh-credentials',
    'token-macro',
    'variant',
    'workflow-api',
    'workflow-basic-steps',
    'workflow-cps-global-lib',
    'workflow-cps',
    'workflow-durable-task-step',
    'workflow-job',
    'workflow-multibranch',
    'workflow-scm-step',
    'workflow-step-api',
    'workflow-support',
  ]

  jenkins::plugin { $plugins : }

  jenkins::job { 'Onceover':
    config  => epp('profile/onceover_jenkins_job.xml'),
    require => Package['jenkins'],
  }

  jenkins::job { 'Controlrepo Test and Deploy':
    config  => epp('profile/controlrepo_deploy_jenkins_job.xml'),
    require => Package['jenkins'],
  }

  include ::profile::base

  include ::profile::nginx

  # Include a reverse proxy in front
  nginx::resource::server { $::hostname:
    listen_port    => 80,
    listen_options => 'default_server',
    proxy          => 'http://localhost:8080',
  }

  # Set Jenkins' default shell to bash
  file { 'jenkins_default_shell':
    ensure  => file,
    path    => '/var/lib/jenkins/hudson.tasks.Shell.xml',
    source  => 'puppet:///modules/profile/hudson.tasks.Shell.xml',
    notify  => Service['jenkins'],
    require => Package['jenkins'],
  }

  # Create a user in the Puppet console for Jenkins
  @@console::user { 'jenkins':
    password     => fqdn_rand_string(20, '', 'jenkins'),
    display_name => 'Jenkins',
    roles        => ['Developers'],
  }

  # Create the details for the Puppet token
  $token = console::user::token('jenkins')
  $secret_json = epp('profile/jenkins_secret_text.json.epp',{
    'id' => 'PE-Deploy-Token',
    'description' => 'Puppet Enterprise Token',
    'secret' => $token,
  })
  $secret_json_escaped = shell_escape($secret_json)

  # If the token has been generated then create it
  if $token {
    jenkins::cli::exec { 'add_secret':
      command => "credentials_update_json <<< ${secret_json_escaped}",
      unless  => "${::jenkins::cli_helper::helper_cmd} credentials_list_json | grep PE-Deploy-Token",
    }
  }
}
