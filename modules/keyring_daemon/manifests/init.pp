class keyring_daemon {
  package { 'keychain':
    ensure => latest,
  }

  package { 'gnome-keyring':
    ensure => absent,
  }
}
