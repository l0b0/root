class browser {
  include window_manager

  package { 'firefox':
    ensure => latest,
  }

  firewall { '100 drop insecure outgoing HTTP traffic':
    chain  => 'OUTPUT',
    dport  => 80,
    proto  => tcp,
    action => reject,
  }
}
