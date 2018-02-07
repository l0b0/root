class automated_certificate_management_environment_client {
  include shell

  package { 'certbot':
    ensure => installed,
  }
}
