class automated_certificate_management_environment_client (
  $package = undef,
) {
  if ($package != undef) {
    include shell

    package { $package:
      ensure => latest,
    }
  }
}
