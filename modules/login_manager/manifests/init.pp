class login_manager {
  package { 'slim':
    ensure => latest,
  }->
  service { 'slim':
    ensure => running,
    enable => true,
  }
}
