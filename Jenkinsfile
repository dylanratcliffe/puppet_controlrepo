node {
   stage('Git Checkout') { // for display purposes
      // Get some code from a GitHub repository
      checkout([
          $class: 'GitSCM',
          branches: [[name: '**']],
          doGenerateSubmoduleConfigurations: false,
          userRemoteConfigs: [[url: 'https://github.com/dylanratcliffe/puppet_controlrepo.git']]])
   }
   stage('Install Gems') {
      // Run the onceover tests
      sh '''source /usr/local/rvm/scripts/rvm
bundle install --path=.gems --binstubs'''
   }
   stage('Run Onceover Tests') {
      // Run the onceover tests
      sh '''source /usr/local/rvm/scripts/rvm
./bin/onceover run spec'''
      junit '.onceover/spec.xml'
   }
  //  stage('Deploy Code') {
  //     git 'https://github.com/dylanratcliffe/puppet_controlrepo.git'
  //     changedFiles = sh(returnStdout: true, script: './scripts/get_changed_classes.rb').trim().split('\n')
  //     echo changedFiles
  //  }
  //  stage('Run Puppet') {
  //     git 'https://github.com/dylanratcliffe/puppet_controlrepo.git'
  //     changedFiles = sh(returnStdout: true, script: './scripts/get_changed_classes.rb').trim().split('\n')
  //     echo changedFiles
  //  }
}
