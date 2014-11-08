root
====

Automated system configuration setup:

- [Installs an excellent browser](https://www.mozilla.org/firefox)
- [Disables the root user password](https://wiki.archlinux.org/index.php/sudo#Disable_root_login)
- [Rate limit SSH connections](https://wiki.archlinux.org/index.php/Uncomplicated_Firewall)
- [Disables root SSH login](http://www.howtogeek.com/howto/linux/security-tip-disable-root-ssh-login-on-linux/?PageSpeed=noscript)
- Enables SSH login only for members of the 'users' group
- [Enable Tor](https://wiki.archlinux.org/index.php/tor)
- [Keep time in sync](https://wiki.archlinux.org/index.php/Network_Time_Protocol_daemon)
- Installs some nice fonts

Any of these can be disabled by removing the appropriate line in `manifests/host.pp`. Some of them are grouped as a single entry in that file, but it should be self-explanatory.

Test
----

    make test

Dependencies:

- `make`
- `puppet`
- `vagrant`
- `virtualbox`

Install
-------

    sudo make install

Dependencies:

- `make`
- `puppet`
- [`ruby-shadow`](https://unix.stackexchange.com/questions/165333/how-to-get-non-zero-exit-code-from-puppet-when-configuration-cannot-be-applied)
