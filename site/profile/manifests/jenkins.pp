class profile::jenkins {
  class { '::jenkins':
    version            => 'latest',
    service_enable     => false,
    configure_firewall => true,
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
  ]

  jenkins::plugin { $plugins : }

  include profile::base

  include ::nginx

  # Include a reverse proxy in front
  nginx::resource::vhost { $::hostname:
    listen_port    => 80,
    listen_options => 'default_server',
    proxy          => 'http://localhost:8080',
  }

}
