class x_server_resource_configuration (
  $dpi = 96,
) {
  include x_server_resource_database_utility

  file { '/etc/X11/Xresources':
    ensure  => present,
    mode    => '0644',
    content => template('x_server_resource_configuration/Xresources.erb'),
  }
}
