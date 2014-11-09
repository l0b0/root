root
====

Automated system configuration setup:

- [Disable the root user password](https://wiki.archlinux.org/index.php/sudo#Disable_root_login)
- [Rate limit SSH connections](https://wiki.archlinux.org/index.php/Uncomplicated_Firewall)
- [Disable root SSH login](http://www.howtogeek.com/howto/linux/security-tip-disable-root-ssh-login-on-linux/)
- Enable SSH login only for members of the ‘users’ group
- [Enable Tor](https://wiki.archlinux.org/index.php/tor)
- [Synchronise time automatically](https://wiki.archlinux.org/index.php/Network_Time_Protocol_daemon)
- Install packages:
    - [Browser](https://www.mozilla.org/firefox)
    - [Battery indicator](https://github.com/valr/cbatticon/) (if necessary)
    - [Password manager](https://www.keepassx.org/)
    - [vCard validator](https://github.com/l0b0/vcard/)
    - Fonts

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

Bugs
----

Please submit bugs using the [project issue tracker](https://github.com/l0b0/root/issues).

License
-------

[GPL v3 or later](LICENSE)

Copyright
---------

© 2014 Victor Engmark
