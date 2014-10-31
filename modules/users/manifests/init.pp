class users {
  package { 'ruby-shadow': }

  user { 'root':
    password => '*',
    require => Package['ruby-shadow'],
  }
}
