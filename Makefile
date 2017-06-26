# from http://www.itnotes.de/docker/development/tools/2014/08/31/speed-up-your-docker-workflow-with-a-makefile/
#include env_make
NS = chrispassurity
VERSION ?= latest


REPO = gradle-cache-resource
AWS_REPO = 892957001504.dkr.ecr.ap-southeast-2.amazonaws.com
NAME = gradle-cache-resource
INSTANCE = default
FOO = bar

.PHONY: install build history tag push push_aws shell run start stop rm release

# putting in a no op to test out external variables (and do nothing as the default target!)
# this will build in to environment and variable injection for docker
noop:
	$(warning bibble$(FOO))
	$(warning bibble$(origin FOO))

install:
#	npm install atlasboard
#	node_modules/.bin/atlasboard install

build:
	docker build -t $(NS)/$(REPO):$(VERSION) .

history:
	docker history $(NS)/$(REPO):$(VERSION)

tag:
	docker tag $(NS)/$(REPO):$(VERSION) $(AWS_REPO)/$(NS)/$(REPO):$(VERSION)

push:
	docker push $(NS)/$(REPO):$(VERSION)

push_aws:
	docker push $(AWS_REPO)/$(NS)/$(REPO):$(VERSION)


shell:
	docker run -u nobody --rm --name $(NAME)-$(INSTANCE) -i -t $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION) /bin/sh

run:
	docker run --rm --name $(NAME)-$(INSTANCE) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION)

start:
	docker run -d --name $(NAME)-$(INSTANCE) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(REPO):$(VERSION)

stop:
	docker stop $(NAME)-$(INSTANCE)

rm:
	docker rm $(NAME)-$(INSTANCE)

release: build
	make push -e VERSION=$(VERSION)

default: build
