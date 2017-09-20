class network_analyzer (
  $ensure = latest,
) {
  include shell

  package { 'gnu-netcat':
    ensure => $ensure,
  }
}
