class password_manager (
  $ensure = latest,
) {
  include window_manager

  package { 'keepassxc':
    ensure => $ensure,
  }
  package { 'keepassx':
    ensure => absent,
  }
}
