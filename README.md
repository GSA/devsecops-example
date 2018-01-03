# DevSecOps example [![CircleCI](https://circleci.com/gh/GSA/devsecops-example.svg?style=svg)](https://circleci.com/gh/GSA/devsecops-example)

This repository is an example of best-practice deployment for the [General Services Administration](https://www.gsa.gov/). More specifically, it demonstrates how to do configuration and deployment for an application that writes to disk. See [the DevSecOps Guide](https://tech.gsa.gov/guides/dev_sec_ops_guide/) for more information.

The example application being deployed is [WordPress](https://wordpress.org/). With a default configuration, WordPress will save uploads, themes, and plugins to the local disk. This means that it violates the [Twelve-Factor App](https://12factor.net/) [Processes](https://12factor.net/processes) rule. While WordPress _can_ be configured to save files elsewhere ([example](https://github.com/dzuelke/wordpress-12factor)), it is being used here as a stand-in for pieces of (legacy?) software that don't have that option.

This is just an example implementation of the GSA DevSecOps principles/component - the repository should still be useful to you, even if you aren't using WordPress, or your architecture isn't exactly the same.

## Architecture

Jenkins is deployed to a hardened Red Hat Enterprise Linux (RHEL) EC2 instance, in a `mgmt` ("management") VPC.

WordPress runs on a hardened Ubuntu 16.04 EC2 instance in a public subnet, and connects to a MySQL RDS instance in a private subnet. All of this is isolated in an `env` ("environment") VPC.

Currently, both the management and environment VPCs will be deployed in the same account, but we are moving to having them separate.

## What's here

* [`terraform/`](terraform/env/) - [Terraform](https://www.terraform.io/) code for setting up the infrastructure at the [Amazon Web Services (AWS)](https://aws.amazon.com/) level, for a management account ([`mgmt/`](terraform/mgmt/)) and application environment(s) ([`env/`](terraform/env/))
* [`packer.json`](packer.json) - [Packer](https://www.packer.io/) template for creating an [Amazon Machine Image (AMI)](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html)
* [`ansible/`](ansible/) - [Ansible](https://docs.ansible.com/ansible/latest/index.html) code for installing WordPress and doing other configuration within the [EC2](https://aws.amazon.com/ec2/) instance, which Packer turns into an AMI

## Setup

1. Set up the AWS CLI.
    1. [Install](https://docs.aws.amazon.com/cli/latest/userguide/installing.html)
    1. [Configure](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)
1. Install additional dependencies:
    * [Ansible](https://docs.ansible.com/ansible/latest/intro_installation.html)
    * [Packer](https://www.packer.io/)
    * [Terraform](https://www.terraform.io/)
1. Install Ansible dependencies.

    ```sh
    ansible-galaxy install -p ansible/roles -r ansible/requirements.yml
    ```

### Management environment

1. Specify a region ([options](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-available-regions)).

    ```sh
    export AWS_DEFAULT_REGION=...
    ```

1. Set up the Terraform backend.

    ```sh
    cd terraform/bootstrap
    terraform init
    terraform apply
    ```

1. Create the Terraform variables file.

    ```sh
    cd ../mgmt
    cp terraform.tfvars.example terraform.tfvars
    ```

1. Fill out [`terraform.tfvars`](terraform/mgmt/terraform.tfvars.example). This file *SHOULD NOT* be checked into source control.
1. Set up Terraform.

    ```sh
    terraform init "-backend-config=bucket=$(cd ../bootstrap && terraform output bucket)"
    ```

1. Bootstrap the environment using Terraform.

    ```sh
    terraform apply -target=aws_eip.jenkins
    ```

    _NOTE: There is a circular dependency between the Terraform and Packer configurations. This workaround only creates the subset of the environment required for the AMI build._

1. Create the Jenkins secrets.
    1. Create a secrets file. _Note that, for simplicity, we're putting the secrets in a file not checked into version control. A real project should put the secrets in a [Vault](https://docs.ansible.com/ansible/latest/vault.html)._

        ```sh
        cp ../../ansible/group_vars/jenkins/secrets.yml.example ../../ansible/group_vars/jenkins/secrets.yml
        ```

    1. [Generate an SSH key.](https://github.com/GSA/jenkins-deploy#usage)
    1. Fill out the secrets file ([`ansible/group_vars/jenkins/secrets.yml`](../ansible/group_vars/jenkins/secrets.yml.example)). This file SHOULD BE VAULTED with [ansible-vault](https://docs.ansible.com/ansible/2.4/vault.html).
1. Run the deployment steps. These steps can be used later to create a new packer build of the jenkins AMI.
    1. Run the following to deploy Jenkins or any other changes to `mgmt`.

        ```sh
        packer build \
        -var jenkins_host=$(terraform output jenkins_host) \
        ../../packer/jenkins.json

        terraform apply
        ```

1. Create the Jenkins pipeline. Note that you will have to login to Jenkins first, using the password specified in the secrets.yml file.
    1. Visit [Blue Ocean](https://jenkins.io/projects/blueocean/) interface.

        ```sh
        open https://$(terraform output jenkins_host)/blue/
        ```

    1. Select `GitHub`.
    1. Use an access token from a shared user.
    1. For the GitHub organization, select `GSA`.
    1. Select `New Pipeline`.
    1. Select this repository.

### Application environment

1. [Create an access key for the deployer user.](https://console.aws.amazon.com/iam/home#/users/circleci-deployer?section=security_credentials)
1. Set up CircleCI for the project.
    * Specify [the required AWS environment variables](https://www.terraform.io/docs/providers/aws/index.html#environment-variables) [in the CircleCI project](https://circleci.com/docs/2.0/env-vars/#adding-environment-variables-in-the-app).
    * The build will bootstrap the environment.
1. Run the steps below to create the Wordpress AMI. Note that this can be used for updating the Wordpress AMI in CI/CD later.
    1. Build the AMI.

        ```sh
        packer build \
        -var db_host=$(terraform output db_host) \
        -var db_name=$(terraform output db_name) \
        -var db_user=$(terraform output db_user) \
        -var db_pass=$(terraform output db_pass) \
        ../../packer/wordpress.json
        ```

    1. Deploy the latest AMI.

        ```sh
        terraform apply
        ```

Note that if the public IP address changes after you set up the site initially, you will need to [change the site URL](https://codex.wordpress.org/Changing_The_Site_URL#Changing_the_Site_URL) in WordPress.

1. Visit the setup page.

    ```sh
    open $(terraform output url)wp-admin/install.php
    ```

#### Troubleshooting

To SSH into the running WordPress instance:

```sh
ssh $(terraform output ssh_user)@$(terraform output public_ip)
```

## Cleanup

Once fully deployed, do the following to delete the project:

1. Temporarily remove [all the `lifecycle` blocks from under `terraform/`](https://github.com/GSA/devsecops-example/search?q=lifecycle+in%3Aterraform).
    * This is necessary because Terraform, as of v0.11.1, [doesn't allow these blocks to contain interpolation](https://github.com/hashicorp/terraform/issues/3116).
1. Destroy the `env`.

    ```sh
    cd terraform/env
    terraform destroy
    ```

1. Destroy `mgmt`.

    ```sh
    cd ../mgmt
    terraform destroy
    ```

1. Destroy `bootstrap`.

    ```sh
    cd ../bootstrap
    terraform destroy
    ```
