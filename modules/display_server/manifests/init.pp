class display_server {
  package { 'xorg-server':
    ensure => installed,
  }
}
