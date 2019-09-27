FROM python:3.7

ENV DEBIAN_FRONTEND="noninteractive"

RUN curl -Lo /tmp/terraform.zip --fail --silent https://releases.hashicorp.com/terraform/0.12.9/terraform_0.12.9_linux_amd64.zip

RUN apt-get -qqy update && apt-get -qqy dist-upgrade && apt-get install -qqy git shellcheck unzip && apt-get -qqy autoremove && apt-get -qqy autoclean

RUN unzip -d /usr/local/bin /tmp/terraform.zip && rm /tmp/terraform.zip

RUN pip install --quiet --upgrade pip
RUN pip install --quiet pre-commit

RUN adduser --system pre-commit

RUN install -d -o pre-commit /pre-install-temp /code

WORKDIR /pre-install-temp
COPY .pre-commit-config.yaml /pre-install-temp/
RUN git init
RUN pre-commit install-hooks

VOLUME /code

WORKDIR /code

ENTRYPOINT pre-commit install-hooks && pre-commit run --all-files
