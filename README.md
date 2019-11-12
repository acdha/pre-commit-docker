# pre-commit Docker packaging

This is just enough Docker to run [pre-commit](https://pre-commit.com) as a CI stage.

## Usage

### Docker

```bash
$ docker run -it --rm --volume "$(pwd)":/code acdha/pre-commit:latest
```

### GitLab CI

```yaml
precommit:
    tags:
        - docker
    image: docker:latest
    services:
        - docker:dind
    before_script:
        - docker pull acdha/pre-commit
    script:
        - docker run --rm --volume "$PWD":/code acdha/pre-commit
```

### GitHub Actions

```yaml
name: CI

on:
    push:
        branches:
            - master

jobs:
    pre-commit:
        runs-on: ubuntu-latest
        steps:
            - uses: actions/checkout@v1
            - name: Fetch pre-commit Docker image
              env:
                  PRE_COMMIT_ACCESS_TOKEN: ${{ secrets.PRE_COMMIT_ACCESS_TOKEN }}
              run: |
                  docker login docker.pkg.github.com -u acdha -p ${PRE_COMMIT_ACCESS_TOKEN}
                  docker pull docker.pkg.github.com/acdha/pre-commit-docker/pre-commit-docker:master
            - name: Run pre-commit
              run: |
                  docker run --volume "$PWD":/code docker.pkg.github.com/acdha/pre-commit-docker/pre-commit-docker:master
```
