# DevSecOps example

TODO

## Setup

1. Set up the AWS CLI.
    1. [Install](https://docs.aws.amazon.com/cli/latest/userguide/installing.html)
    1. [Configure](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)
1. Install [Terraform](https://www.terraform.io/).
1. Set up the Terraform backend.

    ```sh
    aws s3api create-bucket --bucket devsecops-example
    aws s3api put-bucket-versioning --bucket devsecops-example --versioning-configuration Status=Enabled
    ```

1. Set up Terraform.

    ```sh
    export AWS_DEFAULT_REGION=us-east-1
    cd terraform
    terraform init
    ```

## See also

* https://bitbucket.org/mig5/terraform-drupal-example
