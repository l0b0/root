class ssh_throttle::pre {
  Firewall {
    require => undef,
  }

  firewall { '000 accept all icmp':
    proto  => icmp,
    action => accept,
  }->
  firewall { '001 accept all to lo interface':
    proto   => all,
    iniface => lo,
    action  => accept,
  }->
  firewall { '002 accept related established rules':
    proto  => all,
    state  => [RELATED, ESTABLISHED],
    action => accept,
  }->
  firewall { '100 accept ssh':
    proto  => tcp,
    dport  => 22,
    action => accept,
  }
}
