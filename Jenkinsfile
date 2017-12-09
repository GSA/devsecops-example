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
        // TODO make configurable
        AWS_DEFAULT_REGION = 'us-east-2'
      }
      steps {
        sh 'terraform version'

        checkout scm
        sh 'pwd'
        sh 'ls -a'

        // need to `cd` because `dir()` isn't working in Docker
        // https://issues.jenkins-ci.org/browse/JENKINS-33510

        // TODO find better way of specifying this secret
        sh 'cd terraform/env && cp terraform.tfvars.example terraform.tfvars'
        // https://www.terraform.io/guides/running-terraform-in-automation.html#auto-approval-of-plans
        sh 'cd terraform/env && terraform init -input=false'
        // bootstrap the environment with the resources requried for Packer
        sh 'cd terraform/env && terraform apply -input=false -auto-approve -target=aws_route53_record.db'
      }
    }
  }
}
