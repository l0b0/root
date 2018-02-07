class ebook_management_system {
  include window_manager

  package { 'calibre':
    ensure => installed,
  }
}
