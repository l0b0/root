class gem {
  file { '/root/.gemrc':
    ensure => present,
    source => 'puppet:///modules/gem/.gemrc'
  }
}
