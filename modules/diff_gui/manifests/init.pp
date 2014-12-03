class diff_gui {
  include window_manager

  package { 'meld':
    ensure => latest,
  }
}
