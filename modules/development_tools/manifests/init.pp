class development_tools {
  include shell

  package { ['base-devel', 'cmake', 'gdb', 'ruby-bundler']:
    ensure        => installed,
    allow_virtual => true,
  }
}
