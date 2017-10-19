class x_server_compositor {
  package { 'compton':
    ensure => latest,
  }
}
