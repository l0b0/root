GREP = /usr/bin/grep
PING = /usr/bin/ping
PUPPET = /usr/bin/puppet
SLEEP = /usr/bin/sleep
SSH = /usr/bin/ssh
VAGRANT = /usr/bin/vagrant

vm_user = vagrant
vm_ip = 127.0.0.1
vm_port = 2222

vm_test_date_format = %Y-%m-%d
define ntpd_test
set -o errexit -o noclobber -o nounset -o xtrace
vm_test_date=2000-01-01
sudo systemctl stop ntpd.service
sudo systemctl stop vboxservice.service
sudo timedatectl set-timezone UTC
sudo timedatectl set-time $$vm_test_date
[ "$$(date --utc +$(vm_test_date_format))" = "$$vm_test_date" ]
sudo systemctl start ntpd.service
tries=30
while true
do
    if [ "$$(date --utc +$(vm_test_date_format))" = "$(shell date +$(vm_test_date_format))" ]
    then
        break
    else
        sleep 1s
        let --tries
    fi
done
sudo systemctl start vboxservice.service
endef
export ntpd_test

.PHONY: all
all: test

.PHONY: test
test: lint test-deploy

.PHONY: deploy
deploy: $(VAGRANT)
	$(VAGRANT) up --no-provision || [ $$? -eq 2 ]
	$(VAGRANT) provision || [ $$? -eq 2 ]

.PHONY: lint
lint: deploy $(VAGRANT)
	$(VAGRANT) ssh --command '/vagrant/test/lint.sh'

.PHONY: test-deploy
test-deploy: \
	test-battery-indicator \
	test-browser \
	test-firewall \
	test-ntpd \
	test-password-manager \
	test-tor \
	test-users \
	test-vcard-validator

.PHONY: test-battery-indicator
test-battery-indicator: deploy $(GREP) $(VAGRANT)
	# TODO: Use --version after <https://github.com/valr/cbatticon/issues/15> is fixed
	if $(GREP) -q Battery /sys/class/power_supply/*/type; then \
		$(VAGRANT) ssh --command 'cbatticon --help'; \
	fi

.PHONY: test-browser
test-browser: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'firefox --version'

.PHONY: test-firewall
test-firewall: deploy $(SLEEP) $(SSH) $(VAGRANT)
	$(SLEEP) 31s # ensure aborted runs don't sabotage subsequent runs
	for i in 1 2 3 4 5 6; do \
		! $(SSH) -p $(vm_port) -o ConnectTimeout=1 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o PasswordAuthentication=no $(vm_user)@$(vm_ip) || exit 1; \
	done
	! $(VAGRANT) ssh --command 'exit'
	$(SLEEP) 31s
	$(VAGRANT) ssh --command 'exit'

.PHONY: test-ntpd
test-ntpd: deploy $(VAGRANT)
	$(VAGRANT) ssh <<< "$$ntpd_test"

.PHONY: test-password-manager
test-password-manager: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'which keepassx'

.PHONY: test-tor
test-tor: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'torify curl https://check.torproject.org/ | grep -F "Congratulations. This browser is configured to use Tor."'

.PHONY: test-users
test-users: deploy $(VAGRANT)
	$(VAGRANT) ssh --command '[[ "$$(sudo passwd --status root)" =~ ^root\ L\ .*$$ ]]'

.PHONY: test-vcard-validator
test-vcard-validator: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'vcard --help'

.PHONY: install
install: $(PUPPET)
	$(PUPPET) apply --verbose --debug --modulepath modules manifests/host.pp

.PHONY: clean
clean: clean-test

.PHONY: clean-test
clean-test: $(VAGRANT)
	$(VAGRANT) destroy --force
