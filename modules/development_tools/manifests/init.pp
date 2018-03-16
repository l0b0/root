class development_tools {
  include shell

  package { ['base-devel', 'cmake', 'gdb']:
    ensure        => installed,
    allow_virtual => true,
  }
}
