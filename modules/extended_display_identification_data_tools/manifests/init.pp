class extended_display_identification_data_tools (
  $ensure = latest,
) {
  package { 'read-edid':
    ensure => $ensure,
  }
}
