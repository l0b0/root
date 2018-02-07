class image_viewer {
  include window_manager

  package { 'eog':
    ensure => installed,
  }
}
