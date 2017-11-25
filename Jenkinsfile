pipeline {
  agent none

  stages {
    stage('Build') {
      agent { dockerfile true }
      steps {
        echo 'ansible-playbook --version'
        echo 'terraform version'

        checkout scm
        echo 'ls'

        // need to `cd` because `dir()` isn't working in Docker
        // https://issues.jenkins-ci.org/browse/JENKINS-33510
        // TODO find better way of specifying this secret
        sh 'cd terraform/env && cp terraform.tfvars.example terraform.tfvars'
        // https://www.terraform.io/guides/running-terraform-in-automation.html#auto-approval-of-plans
        sh 'cd terraform/env && terraform init -input=false'
        sh 'cd terraform/env && terraform apply -input=false -auto-approve'
      }
    }
  }
}
