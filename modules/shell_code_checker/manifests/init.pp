class shell_code_checker (
  $ensure = latest,
) {
  package { 'shellcheck':
    ensure => $ensure,
  }
}
