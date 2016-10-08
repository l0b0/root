class users {
  package { 'ruby-shadow':
    ensure => present,
  }

  user { 'root':
    password => '*',
    require  => Package[ruby-shadow],
  }
}
