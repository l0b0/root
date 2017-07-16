class plot_generator {
  include shell
  include window_manager

  package { 'gnuplot':
    ensure => latest,
  }
}
