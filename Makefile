PING = /usr/bin/ping
PUPPET = /usr/bin/puppet
SLEEP = /usr/bin/sleep
SSH = /usr/bin/ssh
VAGRANT = /usr/bin/vagrant

PUPPET_LINT_OPTIONS = --no-documentation-check

vm_user = vagrant
vm_ip = 127.0.0.1
vm_port = 2222

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
test-deploy: test-firefox-install test-root-account-lock test-ssh-throttle test-tor

.PHONY: test-tor
test-tor:
	$(VAGRANT) ssh --command 'torify curl https://check.torproject.org/ | grep -F "Congratulations. This browser is configured to use Tor."'

.PHONY: test-ssh-throttle
test-ssh-throttle: deploy
	$(SLEEP) 31s # ensure aborted runs don't sabotage subsequent runs
	for i in 1 2 3 4 5 6; do \
		! $(SSH) -p $(vm_port) -o ConnectTimeout=1 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o PasswordAuthentication=no $(vm_user)@$(vm_ip) || exit 1; \
	done
	! $(VAGRANT) ssh --command 'exit'
	$(SLEEP) 31s
	$(VAGRANT) ssh --command 'exit'

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
