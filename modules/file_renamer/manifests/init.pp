class file_renamer (
  $package = undef,
) {
  include shell

  package { $package:
    ensure => latest,
  }
}
