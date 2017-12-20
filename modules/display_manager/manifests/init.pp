class display_manager {
  include display_server

  package { ['lightdm', 'lightdm-gtk-greeter', 'lightdm-gtk-greeter-settings']:
    ensure => latest,
  } -> service { 'lightdm':
    enable => true,
  }
}
