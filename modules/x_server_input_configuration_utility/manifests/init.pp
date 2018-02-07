class x_server_input_configuration_utility {
  package { 'xorg-xinput':
    ensure => installed,
  }
}
