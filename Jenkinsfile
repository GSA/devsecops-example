pipeline {
  agent none

  triggers {
    // every minute
    pollSCM('* * * * *')
  }

  stages {
    stage('Build') {
      agent {
        docker { image 'hashicorp/terraform' }
      }
      environment {
        AWS_DEFAULT_REGION = 'us-east-2'
      }
      steps {
        sh 'terraform version'

        checkout scm
        sh 'pwd'
        sh 'ls -a'
      }
    }
  }
}
