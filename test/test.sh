#!/usr/bin/env bash

set -o errexit -o noclobber -o nounset -o pipefail -o xtrace

gpg_public_key_fingerprint=92126B54

directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

is_debian() {
    test "$(facter osfamily)" = Debian
}

has_systemd() {
    which systemctl timedatectl
}

gem install --no-document --user-install puppet-lint reek travis-lint
"${directory}/lint.sh"

test-deploy() {
    test-antivirus
    test-battery-indicator
    test-bitmap-image-editor
    test-bittorrent-client
    test-browser
    test-cad-editor
    test-calculator
    test-desktop-management-interface-table-decoder
    test-diagram-editor
    test-diff-gui
    test-dvcs
    test-email-reader
    test-file-copier
    test-file-manager
    test-file-renamer
    test-file-transfer-protocol-client-gui
    test-flash-plugin
    test-fonts
    test-graph-editor
    test-image-viewer
    test-image-viewer-cli
    test-integrated-development-environment
    test-json-processor
    test-login-manager
    test-media-player
    test-newline-converter
    test-network-analyzer
    test-network-manager
    test-ntpd
    test-office-suite
    test-onion-router
    test-open-files-lister
    test-open-document-text-to-plain-text-converter
    test-openpgp-tools
    test-packet-analyzer
    test-panorama-editor
    test-password-manager
    test-pdf-editor
    test-pdf-reader
    test-photo-editor
    test-photo-metadata-editor
    test-printing-system
    test-process-container
    test-scanner
    test-screen-backlight-adjuster
    test-screen-grabber
    test-screen-locker
    test-shell
    test-shell-code-checker
    test-spell-checker
    test-sshd
    test-storage-hardware-monitor
    test-system-call-tracer
    test-terminal
    test-text-editor
    test-undelete-utility
    test-users
    test-vcard-validator
    test-vector-image-editor
    test-video-downloader
    test-window-manager

    test-firewall
}

test-battery-indicator() {
    # Change to `--version` when <https://github.com/valr/cbatticon/issues/17> is fixed
    if grep -q Battery /sys/class/power_supply/*/type; then \
        cbatticon --help; \
    fi
}

test-antivirus() {
    freshclam
    clamscan --quiet /usr/bin
}

test-bitmap-image-editor() {
    gimp --version
}

test-bittorrent-client() {
    which transmission-gtk
}

test-browser() {
    firefox --version
}

test-cad-editor() {
    # TODO: Use --version after <https://github.com/openscad/openscad/issues/1028> is fixed
    is_debian || which openscad
}

test-calculator() {
    test "$(echo 2+2 | bc)" -eq 4
}

test-diagram-editor() {
    dia --version
}

test-desktop-management-interface-table-decoder() {
    dmidecode
}

test-diff-gui() {
    which kdiff3
}

test-dvcs() {
    git --version
}

test-email-reader() {
    is_debian || thunderbird --version
}

test-file-copier() {
    rsync --version
}

test-file-manager() {
    pcmanfm --help
}

test-file-renamer() {
    is_debian || perl-rename --dry-run --verbose "s/md/txt/" "${directory}/README.md"
}

test-file-transfer-protocol-client-gui() {
    # TODO: Use --version when <https://trac.filezilla-project.org/ticket/10671> is fixed
    which filezilla
}

test-firewall() {
    ssh_command=(ssh -p 22000 -o ConnectTimeout=1 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o PasswordAuthentication=no user@docker-container exit)

    for i in 1 2 3 4 5 6; do
        "${ssh_command[@]}"
    done
    ! "${ssh_command[@]}"
    sleep 31s
    "${ssh_command[@]}"
}

test-flash-plugin() {
    is_debian || which flash-player-properties
}

test-fonts() {
    fc-list : family | grep "Liberation"
}

test-graph-editor() {
    dot -V
}

test-image-viewer() {
    eog --version
}

test-image-viewer-cli() {
    feh --version
}

test-integrated-development-environment() {
    # TODO: Find a better test
    # <https://unix.stackexchange.com/questions/229429/how-to-verify-idea-installation-success-with-cli-on-a-vm>
    ls /opt/idea/bin/inspect.sh
}

test-login-manager() {
    systemctl status --no-pager display-manager.service | grep lightdm.service || service lightdm status
}

test-json-processor() {
    jq --version
}

test-media-player() {
    vlc --version
}

test-newline-converter() {
    dos2unix --version
}

test-network-analyzer() {
    "${directory}/netcat.sh"
}

test-network-manager() {
    is_debian || netctl --version
}

test-ntpd() {
    test_date_format=%Y-%m-%d
    test_date=2000-01-01
    if has_systemd
    then
        systemctl stop ntpd.service
        systemctl stop vboxservice.service
        timedatectl set-timezone UTC
        timedatectl set-time $test_date
    else
        service ntp stop
        ln --symbolic --force /usr/share/zoneinfo/UTC /etc/localtime
        date --set=$test_date
    fi
    test "$(date --utc +${test_date_format})" = "$test_date"
    if has_systemd
    then
        systemctl start ntpd.service
    else
        service ntp start
    fi
    tries=30
    while true
    do
        if [ "$(date --utc "+${test_date_format}")" = "$(shell date "+${test_date_format}")" ]
        then
            break
        else
            sleep 1s
            let --tries
        fi
    done
    if has_systemd
    then
        systemctl start vboxservice.service
    fi
}

test-office-suite() {
    is_debian || libreoffice --version
}

test-onion-router() {
    if is_debian
    then
        which torsocks
    else
        torify curl https://check.torproject.org/ | grep -F "Congratulations. This browser is configured to use Tor."
    fi
}

test-open-files-lister() {
    lsof -v
}

test-open-document-text-to-plain-text-converter() {
    odt2txt --version
}

test-openpgp-tools() {
    gpg --keyserver keys.gnupg.net --recv-keys "$gpg_public_key_fingerprint"
}

test-packet-analyzer() {
    if ! is_debian
    then
        wireshark-gtk -v
        tshark -v
    fi
}

test-panorama-editor() {
    which hugin
}

test-password-manager() {
    which keepassx
}

test-pdf-editor() {
    which xournal
}

test-pdf-reader() {
    evince --version
}

test-photo-editor() {
    digikam --version
}

test-photo-metadata-editor() {
    jhead -V
}

test-printing-system() {
    lpstat
}

test-process-container() {
    is_debian || docker info
}

test-scanner() {
    # TODO: Use --version after <https://bugs.launchpad.net/simple-scan/+bug/1394385> is fixed
    which simple-scan
}

test-screen-backlight-adjuster() {
    # TODO: Use -help after <https://bugs.freedesktop.org/show_bug.cgi?id=89358> is fixed,
    # or -version after <https://bugs.freedesktop.org/show_bug.cgi?id=89359> is fixed
    is_debian || which xbacklight
}

test-screen-grabber() {
    scrot --version
}

test-screen-locker() {
    # TODO: Use -v once it returns exit code 0
    which slock
}

test-shell() {
    bash --version
}

test-shell-code-checker() {
    shellcheck "${directory}/*.sh"
}

test-spell-checker() {
    aspell dump dicts
    echo | hunspell -D
}

test-sshd() {
    systemctl status --no-pager sshd || service ssh status
}

test-system-call-tracer() {
    strace -V
}

test-storage-hardware-monitor() {
    smartctl --info /dev/sda
}

test-terminal() {
    xterm -version
}

test-text-editor() {
    vim --version
}

test-undelete-utility() {
    extundelete --help
}

test-users() {
    [[ "$(passwd --status root)" =~ ^root\ L\ .*$ ]]
}

test-vcard-validator() {
    vcard --help
}

test-vector-image-editor() {
    inkscape --version
}

test-video-downloader() {
    youtube-dl --version
}

test-window-manager() {
    awesome --version
}

test-deploy
