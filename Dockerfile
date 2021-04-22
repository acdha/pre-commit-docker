FROM python:3.9-slim-buster

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get -qqy clean && apt-get -qqy update && apt-get -qqy upgrade && apt-get install --no-install-recommends -qqy curl git git-lfs shellcheck busybox && apt-get -qqy autoremove && apt-get -qqy clean && rm -rf /var/lib/apt/lists/*

RUN curl --silent --fail https://releases.hashicorp.com/terraform/0.14.10/terraform_0.14.10_linux_amd64.zip | busybox unzip -d /usr/bin/ /dev/stdin && chmod a+x /usr/bin/terraform

RUN curl --silent --fail -Lo /usr/bin/terraform-docs https://github.com/segmentio/terraform-docs/releases/download/v0.12.1/terraform-docs-v0.12.1-linux-amd64 && chmod 0755 /usr/bin/terraform-docs

RUN pip install --no-cache-dir --quiet --upgrade pip && pip install --no-cache-dir --quiet pre-commit

RUN adduser --system pre-commit

RUN install -d -o pre-commit /code

COPY run-pre-commit /usr/local/bin

WORKDIR /tmp/build

# Allow this repository's configuration to serve as a default which can be
# overwritten by the target repo:
COPY .pre-commit-config.yaml /tmp/build

RUN git init && pre-commit install-hooks && find /tmp/build/ -delete && find /tmp/ -type f -delete

VOLUME /code
WORKDIR /code

ENTRYPOINT ["/usr/local/bin/run-pre-commit"]
