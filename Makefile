PUPPET = /usr/bin/puppet
VAGRANT = /usr/bin/vagrant

PUPPET_LINT_OPTIONS = --no-documentation-check

.PHONY: all
all: test

.PHONY: test
test: lint test-deploy

.PHONY: deploy
deploy:
	$(VAGRANT) up || [ $? -eq 2 ]
	$(VAGRANT) provision

.PHONY: lint
lint: deploy
	$(VAGRANT) ssh --command 'puppet-lint $(PUPPET_LINT_OPTIONS) /vagrant/manifests'
	$(VAGRANT) ssh --command 'puppet-lint $(PUPPET_LINT_OPTIONS) /vagrant/modules'

.PHONY: test-deploy
test-deploy: deploy
	$(VAGRANT) ssh --command 'firefox --version'
	$(VAGRANT) ssh --command '[[ "$$(sudo passwd --status root)" =~ ^root\ LK\ .*$$ ]]'

.PHONY: install
install:
	$(PUPPET) apply --verbose --debug --modulepath modules manifests/host.pp

.PHONY: clean
clean: clean-test

.PHONY: clean-test
clean-test:
	$(VAGRANT) destroy --force

include make-includes/variables.mk
