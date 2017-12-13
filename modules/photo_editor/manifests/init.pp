class photo_editor (
  $ensure = latest,
) {
  include window_manager

  package { ['digikam', 'oxygen-icons', 'qt5ct']:
    ensure => $ensure,
  }
}
