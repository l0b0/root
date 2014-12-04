class office_suite {
  include window_manager

  package {
    [
      'libreoffice-still-calc',
      'libreoffice-still-impress',
      'libreoffice-still-writer']:
    ensure => latest,
  }
}
