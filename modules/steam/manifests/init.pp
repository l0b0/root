class steam {
  include window_manager
  include x_server_video_driver

  file_line { 'Fake OS release number':
    path => '/etc/os-release',
    line => 'VERSION_ID="2015.11.01"',
  }
}
