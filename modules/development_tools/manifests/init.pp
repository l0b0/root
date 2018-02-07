class development_tools {
  include shell

  package { 'base-devel':
    ensure        => installed,
    allow_virtual => true,
  }
}
