pipeline {
  agent none

  stages {
    stage('Build') {
      agent { dockerfile true }
      environment {
        AWS_DEFAULT_REGION = 'us-east-2'
      }
      steps {
        sh 'ansible-playbook --version'
        sh 'terraform version'

        checkout scm

        // need to `cd` because `dir()` isn't working in Docker
        // https://issues.jenkins-ci.org/browse/JENKINS-33510
        // TODO find better way of specifying this secret
        sh 'cd terraform/env && cp terraform.tfvars.example terraform.tfvars'
        // https://www.terraform.io/guides/running-terraform-in-automation.html#auto-approval-of-plans
        // TODO remove the -reconfigure
        sh 'cd terraform/env && terraform init -input=false -reconfigure'
        sh 'cd terraform/env && terraform apply -input=false -auto-approve'
      }
    }
  }
}
