FROM python:3.8

ENV DEBIAN_FRONTEND="noninteractive"

ADD https://releases.hashicorp.com/terraform/0.12.21/terraform_0.12.21_linux_amd64.zip /tmp/

RUN unzip -d /usr/bin/ /tmp/terraform_0.12.21_linux_amd64.zip

ADD https://github.com/segmentio/terraform-docs/releases/download/v0.8.2/terraform-docs-v0.8.2-linux-amd64 /tmp/

RUN install -m 0755 /tmp/terraform-docs-v0.8.2-linux-amd64 /usr/bin/terraform-docs

RUN apt-get -qqy clean && apt-get -qqy update && apt-get -qqy upgrade && apt-get install --no-install-recommends -qqy git shellcheck unzip && apt-get -qqy autoremove && apt-get -qqy clean

RUN pip install --no-cache-dir --quiet --upgrade pip && pip install --no-cache-dir --quiet pre-commit

RUN adduser --system pre-commit

RUN install -d -o pre-commit /code

WORKDIR /code

# Allow this repository's configuration to serve as a default which can be
# overwritten by the target repo:
COPY .pre-commit-config.yaml /code
RUN git init
RUN pre-commit install-hooks

RUN find /tmp/ -type f -delete

VOLUME /code

WORKDIR /code

ENTRYPOINT pre-commit run --all-files
