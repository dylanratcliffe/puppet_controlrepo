class profile::jenkins {
  class { '::jenkins':
    version            => '2.19.3',
    service_enable     => false,
    configure_firewall => true,
    executors          => $::processors['count'],
  }

  $plugins = [
    'promoted-builds',
    'git-client',
    'scm-api',
    'mailer',
    'token-macro',
    'matrix-project',
    'ssh-credentials',
    'parameterized-trigger',
    'maven-plugin',
    'rebuild',
    'script-security',
    'junit',
    'github',
    'git',
    'workflow-aggregator',
    'puppet-enterprise-pipeline',
    'structs',
    'javadoc',
    'workflow-scm-step',
    'workflow-cps',
    'workflow-support',
    'workflow-basic-steps',
    'pipeline-input-step',
    'pipeline-milestone-step',
    'pipeline-build-step',
    'pipeline-stage-view',
    'workflow-multibranch',
    'workflow-durable-task-step',
    'workflow-api',
    'pipeline-stage-step',
    'workflow-cps-global-lib',
    'workflow-step-api',
    'workflow-job',
    'plain-credentials',
    'display-url-api',
    'github-api',
    'conditional-buildstep',
    'momentjs',
    'pipeline-rest-api',
    'handlebars',
    'durable-task',
    'ace-editor',
    'jquery-detached',
    'branch-api',
    'cloudbees-folder',
    'pipeline-graph-analysis',
    'run-condition',
    'git-server',
    'rvm',
    'ruby-runtime',
    'pipeline-model-definition',
    'credentials-binding',
    'docker-workflow',
    'pipeline-model-api',
    'pipeline-model-declarative-agent',
    'pipeline-model-extensions',
    'pipeline-stage-tags-metadata',
    'docker-commons',
    'icon-shim',
    'authentication-tokens',
    'blueocean',
    'blueocean-config',
    'blueocean-pipeline-editor',
    'blueocean-web',
    'blueocean-jwt',
    'blueocean-commons',
    'blueocean-personalization',
    'blueocean-display-url',
    'blueocean-rest-impl',
    'blueocean-autofavorite',
    'blueocean-github-pipeline',
    'blueocean-rest',
    'blueocean-i18n',
    'blueocean-pipeline-api-impl',
    'blueocean-dashboard',
    'blueocean-git-pipeline',
    'blueocean-events',
    'favorite',
    'variant',
    'metrics',
    'jackson2-api',
    'github-branch-source',
    'pubsub-light',
    'sse-gateway',
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

  include profile::base

  include profile::nginx

  # Include a reverse proxy in front
  nginx::resource::server { $::hostname:
    listen_port    => 80,
    listen_options => 'default_server',
    proxy          => 'http://localhost:8080',
  }

  # Set Jenkins' default shell to bash
  file { 'jenkins_default_shell':
    ensure  => present,
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
