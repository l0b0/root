class users (
  $package_ensure = absent,
) {
  package { 'ruby-shadow':
    ensure => $package_ensure,
  }

  user { 'root':
    password => '*',
    require  => Package[ruby-shadow],
  }
}
