class login_manager {
  include display_server

  service { 'slim':
    enable => false,
  }->
  package { ['lightdm', 'lightdm-gtk2-greeter']:
    ensure => latest,
  }->
  service { 'lightdm':
    enable => true,
  }->
  package { 'slim':
    ensure => absent,
  }
}
