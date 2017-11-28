pipeline {
  agent none

  triggers {
    // every minute
    pollSCM('* * * * *')
  }

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
        sh 'whoami'
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

        sh 'ansible-galaxy install -p ansible/roles -r ansible/requirements.yml -vvv'
        sh '''
          cd terraform/env && \
          packer build \
            -var db_host=$(terraform output db_host) \
            -var db_name=$(terraform output db_name) \
            -var db_user=$(terraform output db_user) \
            -var db_pass=$(terraform output db_pass) \
            ../../packer/wordpress.json
        '''

        // build the remaining infrastructure
        sh 'cd terraform/env && terraform apply -input=false -auto-approve'
      }
    }
  }
}
