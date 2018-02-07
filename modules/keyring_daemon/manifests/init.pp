class keyring_daemon {
  package { 'keychain':
    ensure => installed,
  }

  package { 'gnome-keyring':
    ensure => absent,
  }
}
