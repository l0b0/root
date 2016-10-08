class network_manager (
  $packages     = undef,
) {
  if ($packages != undef) {
    include shell

    package { $packages:
      ensure => latest,
    }
  }
}
