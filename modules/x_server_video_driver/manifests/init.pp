class x_server_video_driver (
  $intel = false,
) {
  $intel_ensure = str2bool($intel) ? {
    true    => latest,
    default => absent,
  }

  package { ['xf86-video-fbdev', 'xf86-video-vesa']:
    ensure => latest,
  }

  package { 'xf86-video-intel':
    ensure => $intel_ensure,
  }
}
