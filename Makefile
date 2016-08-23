DOCKER = /usr/bin/docker
PUPPET = /usr/bin/puppet

docker_tag = l0b0/archlinux
docker_root = /media/root

.PHONY: all
all: test

.PHONY: test
test: deploy
	$(DOCKER) run $(docker_tag) $(docker_root)/test/test.sh

.PHONY: deploy
deploy:
	$(DOCKER) build --tag=$(docker_tag) .
	$(DOCKER) run \
		--cap-add=SYS_ADMIN \
		--security-opt=seccomp:unconfined \
		--volume=/sys/fs/cgroup:/sys/fs/cgroup:ro \
		--workdir=$(docker_root) \
		$(docker_tag) \
		$(PUPPET) apply \
			--verbose \
			--debug \
			--modulepath=modules \
			--detailed-exitcodes \
			--hiera_config=hieradata/hiera.yaml \
			manifests/host.pp || [ $$? -eq 2 ]

.PHONY: install
install: $(PUPPET)
	$(PUPPET) apply \
		--verbose \
		--debug \
		--modulepath=modules \
		--detailed-exitcodes \
		--hiera_config=hieradata/hiera.yaml \
		manifests/host.pp || [ $$? -eq 2 ]

.PHONY: clean
clean: clean-deploy

.PHONY: clean-deploy
clean-deploy: $(DOCKER)
	$(DOCKER) stop $(docker_tag)
