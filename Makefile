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
deploy: $(VAGRANT) clean-deploy
	$(VAGRANT) up || [ $$? -eq 2 ]

.PHONY: lint
lint: deploy $(VAGRANT)
	$(VAGRANT) ssh --command '/vagrant/test/lint.sh'

.PHONY: test-deploy
test-deploy: \
	test-battery-indicator \
	test-bitmap-image-editor \
	test-bittorrent-client \
	test-browser \
	test-cad-editor \
	test-calculator \
	test-diagram-editor \
	test-diff-gui \
	test-dvcs \
	test-file-copier \
	test-file-manager \
	test-flash-plugin \
	test-fonts \
	test-graph-editor \
	test-image-viewer \
	test-image-viewer-cli \
	test-login-manager \
	test-media-player \
	test-newline-converter \
	test-ntpd \
	test-office-suite \
	test-open-files-lister \
	test-panorama-editor \
	test-password-manager \
	test-pdf-editor \
	test-pdf-reader \
	test-photo-editor \
	test-printing-system \
	test-scanner \
	test-screen-grabber \
	test-screen-locker \
	test-shell \
	test-spell-checker \
	test-sshd \
	test-system-call-tracer \
	test-terminal \
	test-text-editor \
	test-tor \
	test-users \
	test-vcard-validator \
	test-vector-image-editor \
	test-video-downloader \
	test-window-manager \
	| \
	test-firewall

.PHONY: test-battery-indicator
test-battery-indicator: deploy $(GREP) $(VAGRANT)
	# Change to `--version` when <https://github.com/valr/cbatticon/issues/17> is fixed
	if $(GREP) -q Battery /sys/class/power_supply/*/type; then \
		$(VAGRANT) ssh --command 'cbatticon --help'; \
	fi

.PHONY: test-bitmap-image-editor
test-bitmap-image-editor: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'gimp --version'

.PHONY: test-bittorrent-client
test-bittorrent-client: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'deluge --version'

.PHONY: test-browser
test-browser: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'firefox --version'

.PHONY: test-cad-editor
test-cad-editor: deploy $(VAGRANT)
	# TODO: Use --version after <https://github.com/openscad/openscad/issues/1028> is fixed
	$(VAGRANT) ssh --command 'which openscad'

.PHONY: test-calculator
test-calculator: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'test "$$(echo 2+2 | bc)" -eq 4'

.PHONY: test-diagram-editor
test-diagram-editor: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'dia --version'

.PHONY: test-diff-gui
test-diff-gui: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'which meld'

.PHONY: test-dvcs
test-dvcs: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'git --version'

.PHONY: test-file-copier
test-file-copier: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'rsync --version'

.PHONY: test-file-manager
test-file-manager: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'pcmanfm --help'

.PHONY: test-firewall
test-firewall: deploy $(SLEEP) $(SSH) $(VAGRANT)
	for i in 1 2 3 4 5 6; do \
		! $(SSH) -p $(vm_port) -o ConnectTimeout=1 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o PasswordAuthentication=no $(vm_user)@$(vm_ip) || exit 1; \
	done
	! $(VAGRANT) ssh --command 'exit'
	$(SLEEP) 31s
	$(VAGRANT) ssh --command 'exit'

.PHONY: test-flash-plugin
test-flash-plugin: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'which flash-player-properties'

.PHONY: test-fonts
test-fonts: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'fc-list : family | grep "Liberation"'

.PHONY: test-graph-editor
test-graph-editor: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'dot -V'

.PHONY: test-image-viewer
test-image-viewer: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'eog --version'

.PHONY: test-image-viewer-cli
test-image-viewer-cli: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'feh --version'

.PHONY: test-login-manager
test-login-manager: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'systemctl status display-manager.service | grep lightdm.service'

.PHONY: test-media-player
test-media-player: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'vlc --version'

.PHONY: test-newline-converter
test-newline-converter: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'dos2unix --version'

.PHONY: test-ntpd
test-ntpd: deploy $(VAGRANT)
	$(VAGRANT) ssh <<< "$$ntpd_test"

.PHONY: test-office-suite
test-office-suite: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'libreoffice --version'

.PHONY: test-open-files-lister
test-open-files-lister: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'lsof -v'

.PHONY: test-panorama-editor
test-panorama-editor: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'which hugin'

.PHONY: test-password-manager
test-password-manager: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'which keepassx'

.PHONY: test-pdf-editor
test-pdf-editor: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'which xournal'

.PHONY: test-pdf-reader
test-pdf-reader: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'evince --version'

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

.PHONY: test-shell
test-shell: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'bash --version'

.PHONY: test-spell-checker
test-spell-checker: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'aspell --version'
	$(VAGRANT) ssh --command 'hunspell --version'

.PHONY: test-sshd
test-sshd: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'systemctl status sshd'

.PHONY: test-system-call-tracer
test-system-call-tracer: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'strace -V'

.PHONY: test-terminal
test-terminal: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'xterm -version'

.PHONY: test-text-editor
test-text-editor: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'vim --version'

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

.PHONY: test-video-downloader
test-video-downloader: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'youtube-dl --version'

.PHONY: test-window-manager
test-window-manager: deploy $(VAGRANT)
	$(VAGRANT) ssh --command 'awesome --version'

.PHONY: install
install: $(PUPPET)
	$(PUPPET) apply --verbose --debug --modulepath modules manifests/host.pp

.PHONY: clean
clean: clean-deploy

.PHONY: clean-deploy
clean-deploy: $(VAGRANT)
	$(VAGRANT) destroy --force
