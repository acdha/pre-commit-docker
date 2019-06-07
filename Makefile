all: build dockerhub

build:
	docker build -t pre-commit:latest .

dockerhub:
	docker tag pre-commit:latest acdha/pre-commit:latest
	docker push acdha/pre-commit:latest

test: build
	docker run -it --rm -v $(shell pwd):/code pre-commit-docker:latest
