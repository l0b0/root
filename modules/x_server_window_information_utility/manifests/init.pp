class x_server_window_information_utility {
  include shell

  package { 'xorg-xwininfo':
    ensure => latest,
  }
}
