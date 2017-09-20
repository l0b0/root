class office_suite (
  $ensure = latest,
) {
  include window_manager

  package { 'libreoffice-still':
    ensure => $ensure,
  }
}
