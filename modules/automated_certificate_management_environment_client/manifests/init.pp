class automated_certificate_management_environment_client (
  $ensure = latest,
) {
  include shell

  package { 'certbot':
    ensure => $ensure,
  }
}
