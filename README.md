root
====

System configuration. It currently does the following:

- [Installs an excellent browser](https://www.mozilla.org/firefox)
- [Disables the root user password](https://wiki.archlinux.org/index.php/sudo#Disable_root_login)

Test
----

    make test

Install
-------

    sudo make install
    sudo make install

Yes, twice, [unless you already have `ruby-shadow` installed](https://unix.stackexchange.com/questions/165333/how-to-get-non-zero-exit-code-from-puppet-when-configuration-cannot-be-applied).
