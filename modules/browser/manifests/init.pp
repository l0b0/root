class browser {
  include window_manager

  package { 'firefox':
    ensure => latest,
  }

  firewall { '100 log insecure outgoing HTTP traffic':
    chain      => 'OUTPUT',
    dport      => 80,
    proto      => tcp,
    jump       => 'LOG',
    log_level  => debug,
    log_prefix => 'outgoing HTTP traffic ',
    log_uid    => true,
  } -> firewall { '101 drop insecure outgoing HTTP traffic':
    chain  => 'OUTPUT',
    dport  => 80,
    proto  => tcp,
    action => reject,
  }
}
