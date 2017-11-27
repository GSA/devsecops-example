FROM williamyeh/ansible:alpine3

ARG PACKER_VERSION=1.1.2

ADD https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip /tmp/packer_${PACKER_VERSION}_linux_amd64.zip
RUN unzip /tmp/packer_${PACKER_VERSION}_linux_amd64.zip -d /usr/local/bin

# get newer version of Terraform
# https://pkgs.alpinelinux.org/packages?name=terraform&branch=edge&repo=community
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories
RUN apk add --no-cache git terraform

# required for Packer
# https://groups.google.com/d/msg/packer-tool/92wq5kYOvto/kkzoASaMAQAJ
ENV USER root
WORKDIR /${USER}
