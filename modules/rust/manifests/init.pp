class rust (
  $ensure = latest,
) {
  package { 'rustup':
    ensure => $ensure,
  }
}
