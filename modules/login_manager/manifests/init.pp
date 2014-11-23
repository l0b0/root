class login_manager {
  include display_server

  package { 'slim':
    ensure => latest,
  }->
  service { 'slim':
    ensure => running,
    enable => true,
  }
}
