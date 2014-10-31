PUPPET = /usr/bin/puppet
VAGRANT = /usr/bin/vagrant

PUPPET_LINT_OPTIONS = --no-documentation-check

.PHONY: all
all: test

.PHONY: test
test: lint

.PHONY: deploy
deploy:
	$(VAGRANT) up
	$(VAGRANT) provision

.PHONY: lint
lint: deploy
	$(VAGRANT) ssh --command 'puppet-lint $(PUPPET_LINT_OPTIONS) /vagrant/manifests'
	$(VAGRANT) ssh --command 'puppet-lint $(PUPPET_LINT_OPTIONS) /vagrant/modules'
	$(VAGRANT) ssh --command 'firefox --version'

.PHONY: install
install:
	$(PUPPET) apply --modulepath modules manifests/host.pp

.PHONY: clean
clean: clean-test

.PHONY: clean-test
clean-test:
	$(VAGRANT) destroy --force

include make-includes/variables.mk
