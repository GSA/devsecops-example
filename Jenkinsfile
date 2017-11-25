pipeline {
  agent none

  stages {
    stage('Build') {
      agent { dockerfile true }
      steps {
        echo 'ansible-playbook --version'

        checkout scm
        echo 'ls'

        // need to `cd` because `dir()` isn't working in Docker
        // https://issues.jenkins-ci.org/browse/JENKINS-33510
        sh 'cd terraform/env && cp terraform.tfvars.example terraform.tfvars'
        sh 'cd terraform/env && terraform init'
        sh 'cd terraform/env && terraform apply'
      }
    }
  }
}
