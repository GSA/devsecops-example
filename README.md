# DevSecOps example [![CircleCI](https://circleci.com/gh/GSA/devsecops-example.svg?style=svg)](https://circleci.com/gh/GSA/devsecops-example)

This repository is an example of best-practice deployment for the [General Services Administration](https://www.gsa.gov/). More specifically, it demonstrates how to do configuration and deployment for an application that writes to disk. See [the DevSecOps Guide](https://tech.gsa.gov/guides/dev_sec_ops_guide/) for more information.

The example application being deployed is [WordPress](https://wordpress.org/). With a default configuration, WordPress will save uploads, themes, and plugins to the local disk. This means that it violates the [Twelve-Factor App](https://12factor.net/) [Processes](https://12factor.net/processes) rule. While WordPress _can_ be configured to save files elsewhere ([example](https://github.com/dzuelke/wordpress-12factor)), it is being used here as a stand-in for pieces of (legacy?) software that don't have that option. Jenkins is also deployed.

This is just an example implementation of the GSA DevSecOps principles/component - the repository should still be useful to you, even if you aren't using WordPress, or your architecture isn't exactly the same.

## Architecture

WordPress runs on an Ubuntu 16.04 EC2 instance in a public subnet, and connects to a MySQL RDS instance in a private subnet. All of this is isolated in an application-specific VPC.

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

1. Set up the Terraform backend.

    ```sh
    cd terraform/bootstrap
    terraform init
    terraform apply
    ```
    NOTE: You will need to replace your bucket name with something unique, because bucket names must be unique per-region. If you get an error that the bucket name is not available, then your choice was not unique.

1. Set up environment using Terraform.

    ```sh
    cd ../mgmt
    export AWS_DEFAULT_REGION=us-east-1
    terraform init
    terraform apply
    ```

1. Create the Jenkins secrets.
    1. [Generate an SSH key.](https://github.com/GSA/jenkins-deploy#usage)
    1. Create a secrets file.

        ```sh
        cp ../ansible/group_vars/jenkins/secrets.yml.example ../ansible/group_vars/jenkins/secrets.yml
        ```

    1. Fill out the secrets file ([`ansible/group_vars/jenkins/secrets.yml`](../ansible/group_vars/jenkins/secrets.yml.example)).
1. Deploy Jenkins.

    ```sh
    packer build \
      -var jenkins_host=$(terraform output jenkins_host) \
      ../../packer/jenkins.json

    terraform apply
    ```

### Application environment

1. Set up the Terraform backend.

    ```sh
    aws s3api create-bucket --bucket devsecops-example
    aws s3api put-bucket-versioning --bucket devsecops-example --versioning-configuration Status=Enabled
    ```
    NOTE: You will need to replace your bucket name with something unique, because bucket names must be unique per-region. If you get an error that the bucket name is not available, then your choice was not unique.

1. Create the Terraform variables file.

    ```sh
    cd terraform/env
    cp terraform.tfvars.example terraform.tfvars
    ```

1. Fill out [`terraform.tfvars`](terraform/terraform.tfvars.example).
1. Set up environment using Terraform.

    ```sh
    export AWS_DEFAULT_REGION=us-east-1
    terraform init
    ```

1. Run the [deployment](#deployment) steps below.
1. Visit the setup page.

    ```sh
    open $(terraform output url)wp-admin/install.php
    ```

## Deployment

For initial or subsequent deployment:

1. Set up environment using Terraform.

    ```sh
    terraform apply
    ```

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

## Troubleshooting

To SSH into the running instance:

```sh
ssh $(terraform output ssh_user)@$(terraform output public_ip)
```
