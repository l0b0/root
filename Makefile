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
	test-bitmap-image-editor \
	test-bittorrent \
	test-browser \
	test-calculator \
	test-dvcs \
	test-firewall \
	test-flash \
	test-fonts \
	test-graph-visualizer \
	test-image-viewer \
	test-image-viewer-cli \
	test-login-manager \
	test-media-player \
	test-ntpd \
	test-password-manager \
	test-photo-editor \
	test-printing-system \
	test-scanner \
	test-screen-grabber \
	test-screen-locker \
	test-spell-checker \
	test-sshd \
	test-tor \
	test-users \
	test-vcard-validator \
	test-vector-image-editor \
	test-window-manager

.PHONY: test-battery-indicator
test-battery-indicator: deploy $(GREP) $(VAGRANT)
	# TODO: Use --version after <https://github.com/valr/cbatticon/issues/15> is fixed
	if $(GREP) -q Battery /sys/class/power_supply/*/type; then \
		$(VAGRANT) ssh --command 'cbatticon --help'; \
	fi

.PHONY: test-bitmap-image-editor
test-bitmap-image-editor: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'gimp --version'

.PHONY: test-bittorrent
test-bittorrent: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'deluge --version'

.PHONY: test-browser
test-browser: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'firefox --version'

.PHONY: test-calculator
test-calculator: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'test "$$(echo 2+2 | bc)" -eq 4'

.PHONY: test-dvcs
test-dvcs: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'git --version'

.PHONY: test-firewall
test-firewall: deploy $(SLEEP) $(SSH) $(VAGRANT)
	$(SLEEP) 31s # ensure aborted runs don't sabotage subsequent runs
	for i in 1 2 3 4 5 6; do \
		! $(SSH) -p $(vm_port) -o ConnectTimeout=1 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o PasswordAuthentication=no $(vm_user)@$(vm_ip) || exit 1; \
	done
	! $(VAGRANT) ssh --command 'exit'
	$(SLEEP) 31s
	$(VAGRANT) ssh --command 'exit'

.PHONY: test-flash
test-flash: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'which flash-player-properties'

.PHONY: test-fonts
test-fonts: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'fc-list : family | grep "Liberation"'

.PHONY: test-graph-visualizer
test-graph-visualizer: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'dot -V'

.PHONY: test-image-viewer
test-image-viewer: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'eog --version'

.PHONY: test-image-viewer-cli
test-image-viewer-cli: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'feh --version'

.PHONY: test-login-manager
test-login-manager: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'slim -v'

.PHONY: test-media-player
test-media-player: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'vlc --version'

.PHONY: test-ntpd
test-ntpd: deploy $(VAGRANT)
	$(VAGRANT) ssh <<< "$$ntpd_test"

.PHONY: test-password-manager
test-password-manager: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'which keepassx'

.PHONY: test-photo-editor
test-photo-editor: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'digikam --version'

.PHONY: test-printing-system
test-printing-system: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'cups-config --version'

.PHONY: test-scanner
test-scanner: deploy $(VAGRANT)
	# TODO: Use --version after <https://bugs.launchpad.net/simple-scan/+bug/1394385> is fixed
	$(VAGRANT) ssh --command 'which simple-scan'

.PHONY: test-screen-grabber
test-screen-grabber: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'scrot --version'

.PHONY: test-screen-locker
test-screen-locker: deploy $(VAGRANT)
	# TODO: Use -v once it returns exit code 0
	$(VAGRANT) ssh --command 'which slock'

.PHONY: test-spell-checker
test-spell-checker: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'aspell --version'
	$(VAGRANT) ssh --command 'hunspell --version'

.PHONY: test-sshd
test-sshd: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'systemctl status sshd'

.PHONY: test-tor
test-tor: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'torify curl https://check.torproject.org/ | grep -F "Congratulations. This browser is configured to use Tor."'

.PHONY: test-users
test-users: deploy $(VAGRANT)
	$(VAGRANT) ssh --command '[[ "$$(sudo passwd --status root)" =~ ^root\ L\ .*$$ ]]'

.PHONY: test-vcard-validator
test-vcard-validator: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'vcard --help'

.PHONY: test-vector-image-editor
test-vector-image-editor: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'inkscape --version'

.PHONY: test-window-manager
test-window-manager: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'awesome --version'

.PHONY: install
install: $(PUPPET)
	$(PUPPET) apply --verbose --debug --modulepath modules manifests/host.pp

.PHONY: clean
clean: clean-test

.PHONY: clean-test
clean-test: $(VAGRANT)
	$(VAGRANT) destroy --force
