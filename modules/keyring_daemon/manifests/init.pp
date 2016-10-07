class keyring_daemon {
  package { 'gnome-keyring':
    ensure => latest,
  }
}
