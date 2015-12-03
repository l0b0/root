class packet_analyzer (
  $packages = undef,
) {
  if ($packages != undef) {
    include shell

    package { $packages:
      ensure => latest,
    }
  }
}
