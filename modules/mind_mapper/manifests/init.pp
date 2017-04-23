class mind_mapper {
  include window_manager

  package { 'freemind':
    ensure => latest,
  }
}
