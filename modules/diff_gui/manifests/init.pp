class diff_gui {
  include window_manager

  package { 'kdiff3':
    ensure => latest,
  }
}
