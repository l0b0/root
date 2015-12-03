class process_container (
  $package = undef,
) {
  if ($package != undef) {
    include shell

    package { $package:
      ensure => latest,
    }~>
    service { 'docker':
      ensure => running,
      enable => true,
    }

    warning("Make sure to add privileged users to the 'docker' group.")
  }
}
