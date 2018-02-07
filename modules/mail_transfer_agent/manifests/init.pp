class mail_transfer_agent {
  package { 'nullmailer':
    ensure => installed,
  }
}
