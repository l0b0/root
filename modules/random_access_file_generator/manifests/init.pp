class random_access_file_generator (
  $ensure = latest,
) {
  include shell

  package { 'fortune-mod':
    ensure => $ensure,
  }
}
