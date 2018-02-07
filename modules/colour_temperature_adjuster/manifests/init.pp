class colour_temperature_adjuster {
  include shell

  package { 'redshift':
    ensure => installed,
  }
}
