FROM williamyeh/ansible:ubuntu16.04

RUN apt-get update -y && apt-get install -y git unzip

ARG PACKER_VERSION=1.1.2
ADD https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip /tmp/packer_${PACKER_VERSION}_linux_amd64.zip
RUN unzip /tmp/packer_${PACKER_VERSION}_linux_amd64.zip -d /usr/local/bin

ARG TERRAFORM_VERSION=0.11.0
ADD https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip /tmp/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN unzip /tmp/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin

# required for Packer
# https://groups.google.com/d/msg/packer-tool/92wq5kYOvto/kkzoASaMAQAJ
ENV USER root
