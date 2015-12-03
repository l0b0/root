class java_development_kit (
  $package,
  $set_default_command,
) {
  package { $package:
    ensure => latest,
  }~>
  exec { $set_default_command: }
}
