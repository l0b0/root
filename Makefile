PUPPET = /usr/bin/puppet
PUPPET_LINT = $(wildcard /.gem/ruby/*/bin/puppet-lint)

.PHONY: all
all: test

.PHONY: test
test: lint

.PHONY: lint
lint:
	$(PUPPET_LINT) puppet/manifests
	$(PUPPET_LINT) puppet/modules

.PHONY: install
install:
	$(PUPPET) apply --modulepath puppet/modules puppet/manifests/host.pp
