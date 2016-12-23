node {
    def changedFiles
    stage('Preparation') {
       git 'https://github.com/dylanratcliffe/puppet_controlrepo.git'
       changedFiles = sh(returnStdout: true, script: './scripts/get_changed_classes.rb').trim().split('\n')
       echo changedFiles
       
    }
}
