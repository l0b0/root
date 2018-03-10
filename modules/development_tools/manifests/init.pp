class development_tools {
  include shell

  package { ['base-devel', 'cmake']:
    ensure        => installed,
    allow_virtual => true,
  }
}
