class photo_editor (
  $ensure = latest,
) {
  include window_manager

  package { ['digikam', 'qt5ct']:
    ensure => $ensure,
  }
}
