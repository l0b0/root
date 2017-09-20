class mind_mapper (
  $ensure = latest,
) {
  include window_manager

  package { 'freemind':
    ensure => $ensure,
  }
}
