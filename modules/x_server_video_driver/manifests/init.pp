class x_server_video_driver (
  $intel  = false,
  $nvidia = false,
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

  case str2bool($nvidia) {
    true: {
      $nvidia_package_ensure = latest
      $nvidia_file_ensure = present
    }
    default: {
      $nvidia_package_ensure = absent
      $nvidia_file_ensure = absent
    }
  }
  $nvidia_driver_package = 'nvidia-dkms'

  package { [$nvidia_driver_package, 'lib32-nvidia-utils', 'libvdpau', 'nvidia-settings', 'nvidia-utils']:
    ensure => $nvidia_package_ensure,
  }

  file { '/etc/modprobe.d/50-nvidia.conf':
    ensure => $nvidia_file_ensure,
    source => "puppet:///modules/${module_name}/nvidia.conf",
    mode   => '0644',
  }

  file { '/etc/pacman.d/hooks':
    ensure => directory,
    mode   => '0755',
  } ->
  file { '/etc/pacman.d/hooks/nvidia.hook':
    ensure  => $nvidia_file_ensure,
    content => template("${module_name}/nvidia.hook.erb"),
    mode    => '0644',
  }
}
