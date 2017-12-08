class lightweight_directory_access_protocol_client {
  include shell

  package { 'openldap':
    ensure => latest,
  }
}
