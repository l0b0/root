PUPPET = /usr/bin/puppet
PUPPET_LINT = $(wildcard /.gem/ruby/*/bin/puppet-lint)
VAGRANT = /usr/bin/vagrant

.PHONY: all
all: test

.PHONY: test
test: deploy lint

.PHONY: deploy
deploy:
	$(VAGRANT) up
	$(VAGRANT) provision

.PHONY: lint
lint:
	$(PUPPET_LINT) manifests
	$(PUPPET_LINT) modules

.PHONY: install
install:
	$(PUPPET) apply --modulepath modules manifests/host.pp

.PHONY: clean
clean: clean-test

.PHONY: clean-test
clean-test:
	$(VAGRANT) destroy --force
