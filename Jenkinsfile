pipeline {
  agent none

  stages {
    stage('Build') {
      agent { dockerfile true }
      steps {
        echo 'ansible-playbook --version'

        checkout scm
        echo 'ls'
        dir('terraform/env') {
          sh 'cp terraform.tfvars.example terraform.tfvars'
          sh 'terraform init'
          sh 'terraform apply'
        }
      }
    }
  }
}
