# DevSecOps example

This repository is an example of best-practice deployment for the [General Services Administration](https://www.gsa.gov/). More specifically, it demonstrates how to do configuration and deployment for an application that writes to disk.

The example application being deployed is WordPress. WordPress, by default, saves uploads, themes, etc. to local disk, meaning it violates the [Twelve-Factor App](https://12factor.net/) [Processes](https://12factor.net/processes) rule. While WordPress _can_ be configured to save files elsewhere ([example](https://github.com/dzuelke/wordpress-12factor)), it is being used here as a stand-in for pieces of (legacy?) software that don't have that option.

## What's here

* [`terraform/`](terraform/) - [Terraform](https://www.terraform.io/) code for setting up the infrastructure at the [Amazon Web Services (AWS)](https://aws.amazon.com/) level
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
1. Set up the Terraform backend.

    ```sh
    aws s3api create-bucket --bucket devsecops-example
    aws s3api put-bucket-versioning --bucket devsecops-example --versioning-configuration Status=Enabled
    ```

1. Create the Terraform variables file.

    ```sh
    cd terraform
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
    open http://$(terraform output public_ip)/blog/wp-admin/install.php
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
      -var subnet_id=$(terraform output public_subnet_id) \
      -var db_host=$(terraform output db_host) \
      -var db_name=$(terraform output db_name) \
      -var db_user=$(terraform output db_user) \
      -var db_pass=$(terraform output db_pass) \
      ../packer.json
    ```

1. Deploy the latest AMI.

    ```sh
    terraform apply
    ```
