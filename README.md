# DevSecOps example

TODO

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

1. Set up environment using Terraform.

    ```sh
    export AWS_DEFAULT_REGION=us-east-1
    cd terraform
    terraform init
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
