class x_server_video_driver (
  $intel = false,
) {
  require package_manager

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

  package { ['xf86-video-fbdev', 'xf86-video-vesa', 'lib32-mesa', 'mesa']:
    ensure => latest,
  }

  package { ['xf86-video-intel', 'libva-intel-driver']:
    ensure => $intel_package_ensure,
  }

  file { '/etc/X11/xorg.conf.d/20-intel.conf':
    ensure => $intel_file_ensure,
    source => "puppet:///modules/${module_name}/intel.conf",
    mode   => '0644',
  }
}
