class graph_editor {
  include shell

  package { 'graphviz':
    ensure => latest,
  }
}
