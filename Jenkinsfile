pipeline {
  agent none

  stages {
    stage('Build') {
      agent {
        docker { image 'hashicorp/packer' }
      }
      steps {
        echo 'Building..'
      }
    }
  }
}
