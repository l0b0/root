class cad_editor (
  $ensure = latest,
) {
  include window_manager

  package { 'openscad':
    ensure => $ensure,
  }
}
