class login_manager {
  include display_server

  package { ['lightdm', 'lightdm-gtk-greeter']:
    ensure => latest,
  } -> service { 'lightdm':
    enable => true,
  }
}
