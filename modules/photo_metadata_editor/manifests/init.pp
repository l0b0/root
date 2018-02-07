class photo_metadata_editor {
  include shell

  package { 'jhead':
    ensure => installed,
  }
}
