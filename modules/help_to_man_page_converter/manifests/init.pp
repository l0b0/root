class help_to_man_page_converter {
  include shell

  package { 'help2man':
    ensure => installed,
  }
}
