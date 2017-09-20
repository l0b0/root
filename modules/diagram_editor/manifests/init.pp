class diagram_editor (
  $ensure = latest,
) {
  include window_manager

  package { 'dia':
    ensure => $ensure,
  }
}
