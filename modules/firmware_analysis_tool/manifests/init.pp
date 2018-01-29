class firmware_analysis_tool {
  include shell

  package { 'binwalk':
    ensure => latest,
  }
}
