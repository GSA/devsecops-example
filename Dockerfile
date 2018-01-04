FROM williamyeh/ansible:alpine3

RUN apk add --update git openssh wget

# based on https://github.com/hashicorp/docker-hub-images/pull/49
ARG PACKER_VERSION=1.1.3
ARG PACKER_SHA256SUM=b7982986992190ae50ab2feb310cb003a2ec9c5dcba19aa8b1ebb0d120e8686f
RUN wget -nv https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip && \
    echo "${PACKER_SHA256SUM}  packer_${PACKER_VERSION}_linux_amd64.zip" > packer_${PACKER_VERSION}_SHA256SUMS && \
    sha256sum -cs packer_${PACKER_VERSION}_SHA256SUMS && \
    unzip packer_${PACKER_VERSION}_linux_amd64.zip -d /bin && \
    rm -f packer_${PACKER_VERSION}_linux_amd64.zip

# based on https://github.com/hashicorp/docker-hub-images/blob/69606e49c55a3c5177c746e6c5a868052ee1359d/terraform/Dockerfile-light
ARG TERRAFORM_VERSION=0.11.1
ARG TERRAFORM_SHA256SUM=4e3d5e4c6a267e31e9f95d4c1b00f5a7be5a319698f0370825b459cb786e2f35
RUN wget -nv https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    echo "${TERRAFORM_SHA256SUM}  terraform_${TERRAFORM_VERSION}_linux_amd64.zip" > terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    sha256sum -cs terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin && \
    rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip
