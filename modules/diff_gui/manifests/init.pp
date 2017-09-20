class diff_gui (
  $ensure = latest,
) {
  include window_manager

  package { 'kdiff3':
    ensure => $ensure,
  }
}
