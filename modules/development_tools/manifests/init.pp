class development_tools (
  $ensure = latest,
) {
  include shell

  package { 'base-devel':
    ensure        => $ensure,
    allow_virtual => true,
  }
}
