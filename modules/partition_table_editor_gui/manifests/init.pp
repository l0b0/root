class partition_table_editor_gui {
  include shell

  package { 'gparted':
    ensure => latest,
  }
}
