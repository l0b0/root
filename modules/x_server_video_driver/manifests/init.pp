class x_server_video_driver (
  $intel = false,
) {
  case str2bool($intel) {
    true: {
      $intel_package_ensure = latest
      $intel_file_ensure = present
    }
    default: {
      $intel_package_ensure = absent
      $intel_file_ensure = absent
    }
  }

  package { ['xf86-video-fbdev', 'xf86-video-vesa']:
    ensure => latest,
  }

  package { ['xf86-video-intel', 'lib32-mesa', 'libva-intel-driver', 'mesa']:
    ensure => $intel_package_ensure,
  }

  file { '/etc/X11/xorg.conf.d/20-intel.conf':
    ensure => $intel_file_ensure,
    source => "puppet:///modules/${module_name}/intel.conf",
    mode   => '0644',
  }
}
