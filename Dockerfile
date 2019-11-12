FROM python:3.8

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get -qqy update && apt-get -qqy dist-upgrade && apt-get install -qqy git shellcheck unzip && apt-get -qqy autoremove && apt-get -qqy autoclean

RUN pip install --no-cache-dir --quiet --upgrade pip && pip install --no-cache-dir --quiet pre-commit

RUN adduser --system pre-commit

RUN install -d -o pre-commit /code

WORKDIR /code

# Allow this repository's configuration to serve as a default which can be
# overwritten by the target repo:
COPY .pre-commit-config.yaml /code
RUN git init
RUN pre-commit install-hooks

VOLUME /code

WORKDIR /code

ENTRYPOINT pre-commit run --all-files
