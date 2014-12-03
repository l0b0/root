class login_manager {
  include display_server

  package { ['lightdm', 'lightdm-gtk2-greeter']:
    ensure => latest,
  }->
  service { 'lightdm':
    ensure => running,
    enable => true,
  }

  package { 'slim':
    ensure => absent,
  }->
  service { 'slim':
    enable => false,
  }
}
