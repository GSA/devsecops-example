pipeline {
  agent none

  stages {
    stage('Build') {
      agent { dockerfile true }
      steps {
        echo 'ansible-playbook --version'
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
