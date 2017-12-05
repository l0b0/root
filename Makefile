GEM = /usr/bin/gem
PUPPET = /usr/bin/puppet
VAGRANT = /usr/bin/vagrant

module_test_files = $(wildcard test/modules/*/test.sh)
run_alone_module_test_files = $(wildcard test/run_alone_modules/*/test.sh)

.PHONY: all
all: test

.PHONY: test
test: lint test-modules

.PHONY: deploy
deploy:
	$(VAGRANT) up || [ $$? -eq 2 ]; \

.PHONY: lint
lint: deploy
	$(GEM) install --no-document --user-install puppet-lint reek
	test/lint.sh

.PHONY: test-modules
test-modules: deploy | $(module_test_files) $(run_alone_module_test_files)

.PHONY: $(module_test_files) $(run_alone_module_test_files)
$(module_test_files) $(run_alone_module_test_files):
	test/run_module_test.sh $@

.PHONY: test-project
test-project:
	test/project.sh

.PHONY: install
install: $(PUPPET)
	$(PUPPET) apply --verbose --debug --modulepath modules:vendor --detailed-exitcodes --hiera_config=hieradata/hiera.yaml manifests/host.pp || [ $$? -eq 2 ]

.PHONY: clean
clean: clean-deploy

.PHONY: clean-deploy
clean-deploy: $(VAGRANT)
	$(VAGRANT) destroy --force

include make-includes/variables.mk
include make-includes/xml.mk
