class file_comparison_tool {
  include shell

  package { 'diffoscope':
    ensure => installed,
  }
}
