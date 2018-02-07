class x_server_video_driver (
  $intel  = false,
  $nvidia = false,
) {
  require package_manager

  case str2bool($intel) {
    true: {
      $intel_package_ensure = installed
      $intel_file_ensure = present
    }
    default: {
      $intel_package_ensure = absent
      $intel_file_ensure = absent
    }
  }

  package { ['xf86-video-fbdev', 'xf86-video-vesa', 'lib32-mesa', 'libvdpau', 'mesa']:
    ensure => installed,
  }

  package { ['xf86-video-intel', 'libva-intel-driver']:
    ensure => $intel_package_ensure,
  }

  file { '/etc/X11/xorg.conf.d/20-intel.conf':
    ensure => $intel_file_ensure,
    source => "puppet:///modules/${module_name}/intel.conf",
    mode   => '0644',
  }

  case str2bool($nvidia) {
    true: {
      $nvidia_package_ensure = installed
      $nvidia_file_ensure = present
    }
    default: {
      $nvidia_package_ensure = absent
      $nvidia_file_ensure = absent
    }
  }
  package { ['xf86-video-nouveau']:
    ensure => $nvidia_package_ensure,
  }

  package { ['nvidia-dkms', 'lib32-nvidia-utils', 'nvidia-settings', 'nvidia-utils']:
    ensure => absent,
  }
  file { '/etc/modprobe.d/50-nvidia.conf':
    ensure => absent,
  }
  file { '/etc/pacman.d/hooks/nvidia.hook':
    ensure  => absent,
  }
}
