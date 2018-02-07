class newline_converter {
  include shell

  package { 'dos2unix':
    ensure => installed,
  }
}
