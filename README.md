# pre-commit Docker packaging

This is just enough Docker to run [pre-commit](https://pre-commit.com) as a CI
stage.

Because they are on use on many projects, the following dependencies are
pre-installed:

-   terraform
-   terraform-docs

## Usage

### Docker

```bash
$ docker run -it --rm --volume "$(pwd)":/code acdha/pre-commit:latest
…
```

### GitLab CI

#### Recommended: shared template on LC GitLab

To avoid needing to update the configuration in the future, you can simply
include the template from this repository to run pre-commit during your
project's validate stage:

```yaml
include:
    - project: devops/pre-commit-docker
      file: templates/pre-commit.yml
```

#### Alternate (previous usage)

If you want more control over exactly how the job is run you can configure the
job directly:

```yaml
precommit:
    image:
        name: git.loc.gov:4567/devops/pre-commit-docker/master:latest
        entrypoint: [""]
    script:
        - exec /usr/local/bin/run-pre-commit
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
