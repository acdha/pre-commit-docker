FROM git.loc.gov:4567/devops/docker-hub-mirror/python:3.9

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get -qqy clean && apt-get -qqy update && apt-get -qqy upgrade && apt-get install --no-install-recommends -qqy curl git git-lfs shellcheck busybox && apt-get -qqy autoremove && apt-get -qqy clean && rm -rf /var/lib/apt/lists/*

RUN curl --silent --fail https://releases.hashicorp.com/terraform/1.0.5/terraform_1.0.5_linux_amd64.zip | busybox unzip -d /usr/bin/ /dev/stdin && chmod a+x /usr/bin/terraform

RUN curl --silent --fail -L https://github.com/terraform-docs/terraform-docs/releases/download/v0.15.0/terraform-docs-v0.15.0-linux-amd64.tar.gz | tar -C /usr/bin/ -zx terraform-docs

RUN curl --silent --fail -Lo /usr/bin/hadolint https://github.com/hadolint/hadolint/releases/download/v2.7.0/hadolint-Linux-x86_64 && chmod 0755 /usr/bin/hadolint

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
