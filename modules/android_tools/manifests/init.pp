class android_tools {
  include shell

  package { ['android-tools', 'android-udev']:
    ensure => installed,
  }
}
