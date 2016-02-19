class network_manager (
  $packages     = undef,
  $old_packages = undef,
) {
  if ($packages != undef) {
    include shell

    package { $packages:
      ensure => latest,
    }->
    package { $old_packages:
      ensure => absent,
    }
  }
}
