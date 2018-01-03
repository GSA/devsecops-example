FROM williamyeh/ansible:ubuntu16.04

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000

RUN apt-get update -y && \
  apt-get install -y git unzip

ARG PACKER_VERSION=1.1.3
ADD https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip /tmp/packer_${PACKER_VERSION}_linux_amd64.zip
RUN unzip /tmp/packer_${PACKER_VERSION}_linux_amd64.zip -d /usr/local/bin

ARG TERRAFORM_VERSION=0.11.1
ADD https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip /tmp/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
RUN unzip /tmp/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin

# https://github.com/jenkinsci/docker/blob/ca17603a0ff907728201f6285a4182020b277b87/Dockerfile#L18-L19
RUN groupadd -g ${gid} ${group} && \
      useradd -u ${uid} -g ${gid} -m -s /bin/bash ${user}
USER ${user}
# required for Packer
# https://groups.google.com/d/msg/packer-tool/92wq5kYOvto/kkzoASaMAQAJ
ENV USER ${user}
