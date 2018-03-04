class portable_network_graphics_optimizer {
  include shell

  package { 'optipng':
    ensure => installed,
  }
}
