class photo_metadata_editor (
  $ensure = latest,
) {
  include shell

  package { 'jhead':
    ensure => $ensure,
  }
}
