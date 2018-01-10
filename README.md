# DevSecOps example [![CircleCI](https://circleci.com/gh/GSA/devsecops-example.svg?style=svg)](https://circleci.com/gh/GSA/devsecops-example)

This repository is an example of best-practice deployment for the [General Services Administration](https://www.gsa.gov/). More specifically, it demonstrates how to do configuration and deployment for an application that writes to disk. See [the DevSecOps Guide](https://tech.gsa.gov/guides/dev_sec_ops_guide/) for more information.

The example application being deployed is [WordPress](https://wordpress.org/). With a default configuration, WordPress will save uploads, themes, and plugins to the local disk. This means that it violates the [Twelve-Factor App](https://12factor.net/) [Processes](https://12factor.net/processes) rule. While WordPress _can_ be configured to save files elsewhere ([example](https://github.com/dzuelke/wordpress-12factor)), it is being used here as a stand-in for pieces of (legacy?) software that don't have that option.

This is just an example implementation of the GSA DevSecOps principles/component - the repository should still be useful to you, even if you aren't using WordPress, or your architecture isn't exactly the same.

## Architecture

A `mgmt` ("management") VPC is created.

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
1. Specify a region ([options](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-available-regions)).

    ```sh
    export AWS_DEFAULT_REGION=...
    ```

### Bootstrap

1. [Create the base AMIs](https://github.com/GSA/security-benchmarks#base-images), if they aren't shared with your AWS account already.
1. Set up the Terraform backend.

    ```sh
    cd terraform/bootstrap
    terraform init
    terraform apply
    ```

### Management environment

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

1. Create the management VPC.

    ```sh
    terraform apply
    ```

### Application environment

1. [Create an access key for the deployer user.](https://console.aws.amazon.com/iam/home#/users/circleci-deployer?section=security_credentials)
1. Set up CircleCI for the project.
    * [Specify environment variables](https://circleci.com/docs/2.0/env-vars/#adding-environment-variables-in-the-app):
        * [The required AWS configuration](https://www.terraform.io/docs/providers/aws/index.html#environment-variables)
        * `TF_ENV_BUCKET` - get via `terraform output env_backend_bucket`
        * `TF_VAR_db_pass`
        * `TF_VAR_general_availability_endpoint`
    * Generate a deployer key, and add it under the project settings.

        ```sh
        ssh-keygen -t rsa -b 4096 -f id_rsa_circleci -C "something@some.gov" -N ""
        cat id_rsa_circleci | pbcopy

        # save as private key in CircleCI

        rm id_rsa_circleci*
        ```

    * The build will bootstrap the environment.
1. Visit the site, which is the `url` output from Terraform at the end of the CircleCI run, to complete WordPress setup.

Note that if the public IP address changes after you set up the site initially, you will need to [change the site URL](https://codex.wordpress.org/Changing_The_Site_URL#Changing_the_Site_URL) in WordPress.

#### Troubleshooting

To SSH into the running WordPress instance:

```sh
ssh $(terraform output ssh_user)@$(terraform output public_ip)
```

## Build container

Part of the build runs in [a custom container](https://hub.docker.com/r/18fgsa/devsecops-builder/). To update it:

```sh
docker build --pull -t 18fgsa/devsecops-builder:alpine - < Dockerfile
docker push 18fgsa/devsecops-builder:alpine
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
