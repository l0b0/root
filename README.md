root
====

Automated system configuration setup:

- [Disable the root user password](https://wiki.archlinux.org/index.php/sudo#Disable_root_login)
- [Rate limit SSH connections](https://wiki.archlinux.org/index.php/Uncomplicated_Firewall)
- [Disable root SSH login](http://www.howtogeek.com/howto/linux/security-tip-disable-root-ssh-login-on-linux/)
- Enable SSH login only for members of the ‘users’ group
- [Enable Tor](https://wiki.archlinux.org/index.php/tor)
- Set up non-default keyboard layout (change/remove in `modules/keyboard_layout/files/vconsole.conf`)
- [Synchronise time automatically](https://wiki.archlinux.org/index.php/Network_Time_Protocol_daemon)
- Install latest version of packages:
    - [Antivirus](http://www.clamav.net/)
    - [Automated Certificate Management Environment (ACME) client](https://letsencrypt.org/)
    - [Battery indicator](https://github.com/valr/cbatticon/) (if necessary)
    - [Bitmap image editor](http://www.gimp.org/)
    - [BitTorrent client](http://www.transmissionbt.com/)
    - [Browser](https://www.mozilla.org/firefox)
    - [CAD editor](http://www.openscad.org/) (Arch Linux only)
    - [Calculator](https://www.gnu.org/software/bc/)
    - [Desktop Management Interface (DMI) table decoder](http://www.nongnu.org/dmidecode/)
    - [Diagram editor](http://dia-installer.de/)
    - [Distributed version control system](http://git-scm.com/)
    - [Email reader](https://www.mozilla.org/en-GB/thunderbird/) (Arch Linux only)
    - [File copier](http://rsync.samba.org/)
    - [File manager](http://wiki.lxde.org/en/PCManFM)
    - [File recovery utility](http://extundelete.sourceforge.net/)
    - [File renamer](http://search.cpan.org/~pederst/rename/)
    - [File Transfer Protocol (FTP) client](https://filezilla-project.org/)
    - Fonts
    - [Graph editor](http://www.graphviz.org/)
    - Image viewer [GUI](https://wiki.gnome.org/Apps/EyeOfGnome) and [CLI](http://feh.finalrewind.org/)
    - [JSON processor](https://stedolan.github.io/jq/)
    - [Media player](https://www.videolan.org/vlc/)
    - [Network analyzer](http://netcat.sourceforge.net/)
    - [Network manager](https://wiki.archlinux.org/index.php/Netctl) (Arch Linux only)
    - [Packet capture (pcap) analyzer](https://www.wireshark.org/) (Arch Linux only)
    - [Panorama editor](http://hugin.sourceforge.net/)
    - [Password manager](https://www.keepassx.org/)
    - [PDF editor](http://xournal.sourceforge.net/)
    - [PDF reader](https://wiki.gnome.org/Apps/Evince)
    - [OpenPGP tools](https://www.gnupg.org/)
    - [Open Document Text (ODT) to plain text converter](https://github.com/dstosberg/odt2txt/)
    - [Photo editor](https://www.digikam.org/)
    - [Photo metadata editor](http://www.sentex.net/~mwandel/jhead/)
    - [Printing system](https://www.cups.org/) with [service auto-discovery](http://avahi.org/) (the latter is Arch Linux only)
    - [Process container](https://www.docker.com/) (Arch Linux only)
    - [Scanner](https://launchpad.net/simple-scan)
    - [Screen backlight adjuster](http://www.x.org/wiki/UserDocumentation/GettingStarted/) (Arch Linux only)
    - [Screen grabber](http://freecode.com/projects/scrot)
    - [Screen locker](http://tools.suckless.org/slock/)
    - [Shell](https://www.gnu.org/software/bash/)
    - Spell checkers for English, French and German
    - [SSH client and server](http://www.openssh.com/)
    - [Storage hardware monitor](https://www.smartmontools.org/)
    - [Office suite](http://www.libreoffice.org/) (Arch Linux only)
    - [Terminal](http://invisible-island.net/xterm/)
    - [Text editor](http://www.vim.org/)
    - [Onion router](https://www.torproject.org/)
    - [vCard validator](https://github.com/l0b0/vcard/)
    - [Vector image editor](https://inkscape.org/)
    - [Video](https://rg3.github.io/youtube-dl/) & [web](https://www.gnu.org/software/wget/) downloaders
    - [Window manager](http://awesome.naquadah.org/)
- General purpose development tools:
    - [Diff and merge GUI](http://kdiff3.sourceforge.net/)
    - [Integrated development environment](https://www.jetbrains.com/idea/)
    - [Newline converter](http://dos2unix.sourceforge.net/)
    - [Open files lister](http://people.freebsd.org/~abe/)
    - [Shell script static analysis tool](http://www.shellcheck.net/)
    - [System call tracer](http://sourceforge.net/projects/strace/)

Any of these can be disabled by removing the appropriate line in [`manifests/host.pp`](manifests/host.pp). Some of them are grouped as a single entry in that file, but it should be self-explanatory.

Test
----

    make test

Dependencies:

- `make`
- `vagrant`
- `vagrant-reload` plugin
- `virtualbox`

Install
-------

    sudo make install

Dependencies:

- `make`
- `puppet`
- [`ruby-shadow`](https://unix.stackexchange.com/questions/165333/how-to-get-non-zero-exit-code-from-puppet-when-configuration-cannot-be-applied)

Bugs
----

Please submit bugs using the [project issue tracker](https://github.com/l0b0/root/issues).

License
-------

[GPL v3 or later](LICENSE)

Code of Conduct
---------------

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

Copyright
---------

© 2014-2016 Victor Engmark
