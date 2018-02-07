class optical_disk_recording_tools {
  include shell

  package { 'cdrtools':
    ensure => installed,
  }
}
