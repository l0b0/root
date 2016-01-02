GREP = /usr/bin/grep
MAKE = /usr/bin/make
PUPPET = /usr/bin/puppet
SLEEP = /usr/bin/sleep
SSH = /usr/bin/ssh
SUDO = /usr/bin/sudo
VAGRANT = /usr/bin/vagrant

vm_shell = $(VAGRANT) ssh --command

makefile_directory := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

gpg_public_key_fingerprint = 92126B54

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
        $(SLEEP) 1s
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
deploy:
	# Vagrant only
	if [ -e "$(VAGRANT)" ]; then \
		$(VAGRANT) up || [ $$? -eq 2 ]; \
	fi


.PHONY: lint
lint: deploy
	$(vm_shell) '/vagrant/test/lint.sh'

.PHONY: test-deploy
test-deploy: \
	test-battery-indicator \
	test-bitmap-image-editor \
	test-bittorrent-client \
	test-browser \
	test-cad-editor \
	test-calculator \
	test-desktop-management-interface-table-decoder \
	test-diagram-editor \
	test-diff-gui \
	test-dvcs \
	test-email-reader \
	test-file-copier \
	test-file-manager \
	test-file-renamer \
	test-file-transfer-protocol-client-gui \
	test-flash-plugin \
	test-fonts \
	test-graph-editor \
	test-image-viewer \
	test-image-viewer-cli \
	test-integrated-development-environment \
	test-json-processor \
	test-login-manager \
	test-media-player \
	test-newline-converter \
	test-network-analyzer \
	test-network-manager \
	test-ntpd \
	test-office-suite \
	test-onion-router \
	test-open-files-lister \
	test-openpgp-tools \
	test-packet-analyzer \
	test-panorama-editor \
	test-password-manager \
	test-pdf-editor \
	test-pdf-reader \
	test-photo-editor \
	test-photo-metadata-editor \
	test-printing-system \
	test-process-container \
	test-puppet-linter \
	test-ruby-linter \
	test-scanner \
	test-screen-backlight-adjuster \
	test-screen-grabber \
	test-screen-locker \
	test-shell \
	test-spell-checker \
	test-sshd \
	test-storage-hardware-monitor \
	test-system-call-tracer \
	test-terminal \
	test-text-editor \
	test-travis-linter \
	test-undelete-utility \
	test-users \
	test-vcard-validator \
	test-vector-image-editor \
	test-video-downloader \
	test-window-manager \
	| \
	test-firewall

.PHONY: test-battery-indicator
test-battery-indicator: deploy $(GREP)
	# Change to `--version` when <https://github.com/valr/cbatticon/issues/17> is fixed
	if $(GREP) -q Battery /sys/class/power_supply/*/type; then \
		$(vm_shell) 'cbatticon --help'; \
	fi

.PHONY: test-bitmap-image-editor
test-bitmap-image-editor: deploy
	$(vm_shell) 'gimp --version'

.PHONY: test-bittorrent-client
test-bittorrent-client: deploy
	$(vm_shell) 'deluge --version'

.PHONY: test-browser
test-browser: deploy
	$(vm_shell) 'firefox --version'

.PHONY: test-cad-editor
test-cad-editor: deploy
	# TODO: Use --version after <https://github.com/openscad/openscad/issues/1028> is fixed
	$(vm_shell) 'which openscad'

.PHONY: test-calculator
test-calculator: deploy
	$(vm_shell) 'test "$$(echo 2+2 | bc)" -eq 4'

.PHONY: test-diagram-editor
test-diagram-editor: deploy
	$(vm_shell) 'dia --version'

.PHONY: test-desktop-management-interface-table-decoder
test-desktop-management-interface-table-decoder: deploy
	$(vm_shell) 'sudo dmidecode'

.PHONY: test-diff-gui
test-diff-gui: deploy
	$(vm_shell) 'which kdiff3'

.PHONY: test-dvcs
test-dvcs: deploy
	$(vm_shell) 'git --version'

.PHONY: test-email-reader
test-email-reader: deploy
	$(vm_shell) 'thunderbird --version'

.PHONY: test-file-copier
test-file-copier: deploy
	$(vm_shell) 'rsync --version'

.PHONY: test-file-manager
test-file-manager: deploy
	$(vm_shell) 'pcmanfm --help'

.PHONY: test-file-renamer
test-file-renamer: deploy
	$(vm_shell) 'perl-rename --dry-run --verbose "s/md/txt/" /vagrant/README.md'

.PHONY: test-file-transfer-protocol-client-gui
test-file-transfer-protocol-client-gui: deploy
	# TODO: Use --version when <https://trac.filezilla-project.org/ticket/10671> is fixed
	$(vm_shell) 'which filezilla'

.PHONY: test-firewall
test-firewall: deploy $(SLEEP) $(SSH) $(VAGRANT)
	for i in 1 2 3 4 5 6; do \
		! $(SSH) -p $(vm_port) -o ConnectTimeout=1 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o PasswordAuthentication=no $(vm_user)@$(vm_ip) || exit 1; \
	done
	! $(vm_shell) 'exit'
	$(SLEEP) 31s
	$(vm_shell) 'exit'

.PHONY: test-flash-plugin
test-flash-plugin: deploy
	$(vm_shell) 'which flash-player-properties'

.PHONY: test-fonts
test-fonts: deploy
	$(vm_shell) 'fc-list : family | grep "Liberation"'

.PHONY: test-graph-editor
test-graph-editor: deploy
	$(vm_shell) 'dot -V'

.PHONY: test-image-viewer
test-image-viewer: deploy
	$(vm_shell) 'eog --version'

.PHONY: test-image-viewer-cli
test-image-viewer-cli: deploy
	$(vm_shell) 'feh --version'

.PHONY: test-integrated-development-environment
test-integrated-development-environment: deploy
	# TODO: Find a better test
	# <https://unix.stackexchange.com/questions/229429/how-to-verify-idea-installation-success-with-cli-on-a-vm>
	$(vm_shell) 'ls /opt/idea/bin/inspect.sh'

.PHONY: test-login-manager
test-login-manager: deploy
	$(vm_shell) 'systemctl status display-manager.service | grep lightdm.service'

.PHONY: test-json-processor
test-json-processor: deploy
	$(vm_shell) 'jq --version'

.PHONY: test-media-player
test-media-player: deploy
	$(vm_shell) 'vlc --version'

.PHONY: test-newline-converter
test-newline-converter: deploy
	$(vm_shell) 'dos2unix --version'

.PHONY: test-network-analyzer
test-network-analyzer: deploy
	$(vm_shell) '/vagrant/test/netcat.sh'

.PHONY: test-network-manager
test-network-manager: deploy
	$(vm_shell) 'sudo wicd-cli --wireless --list-networks'

.PHONY: test-ntpd
test-ntpd: deploy
	$(VAGRANT) ssh <<< "$$ntpd_test"

.PHONY: test-office-suite
test-office-suite: deploy
	$(vm_shell) 'libreoffice --version'

.PHONY: test-onion-router
test-onion-router: deploy
	$(vm_shell) 'torify curl https://check.torproject.org/ | grep -F "Congratulations. This browser is configured to use Tor."'

.PHONY: test-open-files-lister
test-open-files-lister: deploy
	$(vm_shell) 'lsof -v'

.PHONY: test-openpgp-tools
test-openpgp-tools: deploy
	$(vm_shell) 'gpg --keyserver keys.gnupg.net --recv-keys $(gpg_public_key_fingerprint)'

.PHONY: test-packet-analyzer
test-packet-analyzer: deploy
	$(vm_shell) 'wireshark-gtk -v'
	$(vm_shell) 'tshark -v'

.PHONY: test-panorama-editor
test-panorama-editor: deploy
	$(vm_shell) 'which hugin'

.PHONY: test-password-manager
test-password-manager: deploy
	$(vm_shell) 'which keepassx'

.PHONY: test-pdf-editor
test-pdf-editor: deploy
	$(vm_shell) 'which xournal'

.PHONY: test-pdf-reader
test-pdf-reader: deploy
	$(vm_shell) 'evince --version'

.PHONY: test-photo-editor
test-photo-editor: deploy
	$(vm_shell) 'digikam --version'

.PHONY: test-photo-metadata-editor
test-photo-metadata-editor: deploy
	$(vm_shell) 'jhead -V'

.PHONY: test-printing-system
test-printing-system: deploy
	$(vm_shell) 'cups-config --version'

.PHONY: test-process-container
test-process-container: deploy
	$(vm_shell) 'sudo docker info'

.PHONY: test-puppet-linter
test-puppet-linter: deploy
	$(vm_shell) 'puppet-lint --help'

.PHONY: test-ruby-linter
test-ruby-linter: deploy
	$(vm_shell) 'reek --help'

.PHONY: test-scanner
test-scanner: deploy
	# TODO: Use --version after <https://bugs.launchpad.net/simple-scan/+bug/1394385> is fixed
	$(vm_shell) 'which simple-scan'

.PHONY: test-screen-backlight-adjuster
test-screen-backlight-adjuster: deploy
	# TODO: Use -help after <https://bugs.freedesktop.org/show_bug.cgi?id=89358> is fixed,
	# or -version after <https://bugs.freedesktop.org/show_bug.cgi?id=89359> is fixed
	$(vm_shell) 'which xbacklight'

.PHONY: test-screen-grabber
test-screen-grabber: deploy
	$(vm_shell) 'scrot --version'

.PHONY: test-screen-locker
test-screen-locker: deploy
	# TODO: Use -v once it returns exit code 0
	$(vm_shell) 'which slock'

.PHONY: test-shell
test-shell: deploy
	$(vm_shell) 'bash --version'

.PHONY: test-spell-checker
test-spell-checker: deploy
	$(vm_shell) 'aspell dump dicts'
	$(vm_shell) 'echo | hunspell -D'

.PHONY: test-sshd
test-sshd: deploy
	$(vm_shell) 'systemctl status sshd'

.PHONY: test-system-call-tracer
test-system-call-tracer: deploy
	$(vm_shell) 'strace -V'

.PHONY: test-storage-hardware-monitor
test-storage-hardware-monitor: deploy
	$(vm_shell) 'sudo smartctl --info /dev/sda'

.PHONY: test-terminal
test-terminal: deploy
	$(vm_shell) 'xterm -version'

.PHONY: test-text-editor
test-text-editor: deploy
	$(vm_shell) 'vim --version'

.PHONY: test-travis-linter
test-travis-linter: deploy
	$(vm_shell) 'which travis-lint'

.PHONY: test-undelete-utility
test-undelete-utility: deploy
	$(vm_shell) 'extundelete --help'

.PHONY: test-users
test-users: deploy
	$(vm_shell) '[[ "$$(sudo passwd --status root)" =~ ^root\ L\ .*$$ ]]'

.PHONY: test-vcard-validator
test-vcard-validator: deploy
	$(vm_shell) 'vcard --help'

.PHONY: test-vector-image-editor
test-vector-image-editor: deploy
	$(vm_shell) 'inkscape --version'

.PHONY: test-video-downloader
test-video-downloader: deploy
	$(vm_shell) 'youtube-dl --version'

.PHONY: test-window-manager
test-window-manager: deploy
	$(vm_shell) 'awesome --version'

.PHONY: install
install: $(PUPPET)
	$(PUPPET) apply --verbose --debug --modulepath modules --detailed-exitcodes --hiera_config=hieradata/hiera.yaml manifests/host.pp || [ $$? -eq 2 ]

.PHONY: clean
clean: clean-deploy

.PHONY: clean-deploy
clean-deploy: $(VAGRANT)
	$(VAGRANT) destroy --force

include vm.mk
