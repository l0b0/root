class nodejs_dependency_manager {
  package { 'yarn':
    ensure => latest,
  }
}
