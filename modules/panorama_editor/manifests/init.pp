class panorama_editor (
  $ensure = latest,
) {
  include window_manager

  package { 'hugin':
    ensure => $ensure,
  }
}
