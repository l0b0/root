class plot_generator (
  $ensure = latest,
) {
  include shell
  include window_manager

  package { 'gnuplot':
    ensure => $ensure,
  }
}
