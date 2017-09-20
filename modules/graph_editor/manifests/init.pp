class graph_editor (
  $ensure = latest,
) {
  include shell

  package { 'graphviz':
    ensure => $ensure,
  }
}
