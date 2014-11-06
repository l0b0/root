PING = /usr/bin/ping
PUPPET = /usr/bin/puppet
VAGRANT = /usr/bin/vagrant

PUPPET_LINT_OPTIONS = --no-documentation-check

vm_ip = 192.168.100.100

.PHONY: all
all: test

.PHONY: test
test: lint test-deploy

.PHONY: deploy
deploy:
	$(VAGRANT) up || [ $$? -eq 2 ]
	$(VAGRANT) provision || [ $$? -eq 2 ]

.PHONY: lint
lint: deploy
	$(VAGRANT) ssh --command '~/.gem/ruby/*/gems/puppet-lint-*/bin/puppet-lint $(PUPPET_LINT_OPTIONS) /vagrant/manifests'
	$(VAGRANT) ssh --command '~/.gem/ruby/*/gems/puppet-lint-*/bin/puppet-lint $(PUPPET_LINT_OPTIONS) /vagrant/modules'

.PHONY: test-deploy
test-deploy: test-firefox-install test-root-account-lock

.PHONY: test-root-account-lock
test-root-account-lock: deploy
	$(VAGRANT) ssh --command '[[ "$$(sudo passwd --status root)" =~ ^root\ L\ .*$$ ]]'

.PHONY: test-firefox-install
test-firefox-install: deploy
	$(VAGRANT) ssh --command 'firefox --version'

.PHONY: install
install:
	$(PUPPET) apply --verbose --debug --modulepath modules manifests/host.pp

.PHONY: clean
clean: clean-test

.PHONY: clean-test
clean-test:
	$(VAGRANT) destroy --force

include make-includes/variables.mk
