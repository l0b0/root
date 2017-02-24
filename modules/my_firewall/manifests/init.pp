class my_firewall {
  include my_firewall::pre
  include my_firewall::post

  package { 'ufw':
    ensure => absent,
  }
}
