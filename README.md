root
====

System configuration. It currently does the following:

- [Installs an excellent browser](https://www.mozilla.org/firefox)
- [Disables the root user password](https://wiki.archlinux.org/index.php/sudo#Disable_root_login)
- [Rate limit SSH connections](https://wiki.archlinux.org/index.php/Uncomplicated_Firewall)
- [Disables root SSH login](http://www.howtogeek.com/howto/linux/security-tip-disable-root-ssh-login-on-linux/?PageSpeed=noscript)
- Enables SSH login only for members of the 'users' group

Test
----

Dependencies:

- `make`
- `puppet`
- `vagrant`
- `virtualbox`

    make test

Install
-------

Dependencies:

- `make`
- `puppet`
- [`ruby-shadow`](https://unix.stackexchange.com/questions/165333/how-to-get-non-zero-exit-code-from-puppet-when-configuration-cannot-be-applied)

    sudo make install
