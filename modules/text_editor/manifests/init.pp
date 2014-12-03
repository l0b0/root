class text_editor {
  include shell

  package { 'vim':
    ensure => latest,
  }
}
