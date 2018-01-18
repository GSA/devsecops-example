FROM hashicorp/packer:light as packer
FROM hashicorp/terraform:light as terraform

FROM williamyeh/ansible:alpine3
COPY --from=packer /bin/packer /bin/packer
COPY --from=terraform /bin/terraform /bin/terraform

RUN apk add --no-cache git make

RUN pip install awscli --upgrade --user
ENV PATH="/root/.local/bin:${PATH}"
