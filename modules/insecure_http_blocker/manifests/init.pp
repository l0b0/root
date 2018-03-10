class insecure_http_blocker (
  $ensure = absent,
) {
  $ipv4_private_network_hosts = [
    '10.0.0.0/8',
    '127.0.0.0/8',
    '172.16.0.0/12',
    '192.168.0.0/16',
  ]
  $ipv4_private_network_hosts_index_start = 100
  $ipv4_private_network_hosts.each |Integer $index, String $host| {
    $rule_number = $ipv4_private_network_hosts_index_start + $index
    firewall { join([$rule_number, 'allow outgoing HTTP traffic to IPv4 private network'], ' '):
      ensure      => $ensure,
      chain       => 'OUTPUT',
      destination => $host,
      dport       => 80,
      proto       => tcp,
      action      => accept,
      provider    => 'iptables',
    }
  }

  $ipv6_private_network_hosts = [
    'fc00::/7',
  ]
  $ipv6_private_network_hosts_index_start = $ipv4_private_network_hosts_index_start + size($ipv4_private_network_hosts)
  $ipv6_private_network_hosts.each |Integer $index, String $host| {
    $rule_number = $ipv6_private_network_hosts_index_start + $index
    firewall { join([$rule_number, 'allow outgoing HTTP traffic to IPv6 private network'], ' '):
      ensure      => $ensure,
      chain       => 'OUTPUT',
      destination => $host,
      dport       => 80,
      proto       => tcp,
      action      => accept,
      provider    => 'ip6tables',
    }
  }

  $ocsp_hosts = [
    'clients1.google.com',
    'commercial.ocsp.identrust.com',
    'gp.symcd.com',
    'mssl-ocsp.ws.symantec.com',
    'ocsp.comodoca.com',
    'ocsp.digicert.com',
    'ocsp.int-x3.letsencrypt.org',
    'ocsp.msocsp.com',
    'ocsp.sca1b.amazontrust.com',
    'ocsp.trendmicro.com',
    'ocsp.usertrust.com',
    'ocsp2.globalsign.com',
  ]
  $ocsp_hosts_index_start = $ipv6_private_network_hosts_index_start + size($ipv6_private_network_hosts)
  $ocsp_hosts.each |Integer $index, String $host| {
    $rule_number = $ocsp_hosts_index_start + $index
    firewall { join([$rule_number, 'allow outgoing HTTP traffic to IPv4 OCSP responders'], ' '):
      ensure      => $ensure,
      chain       => 'OUTPUT',
      destination => $host,
      dport       => 80,
      proto       => tcp,
      action      => accept,
      provider    => 'iptables',
    }
  }

  $log_entry_index_start = $ocsp_hosts_index_start + size($ocsp_hosts)
  ['iptables', 'ip6tables'].each |Integer $index, String $provider| {
    $rule_number = $log_entry_index_start + $index
    firewall { "${rule_number} log insecure outgoing HTTP traffic":
      ensure     => $ensure,
      chain      => 'OUTPUT',
      dport      => 80,
      proto      => tcp,
      jump       => 'LOG',
      log_level  => debug,
      log_prefix => 'outgoing HTTP traffic ',
      log_uid    => true,
      provider   => $provider,
    }
  }

  $drop_entry_index_start = $log_entry_index_start + 2
  ['iptables', 'ip6tables'].each |Integer $index, String $provider| {
    $rule_number = $drop_entry_index_start + $index
    firewall { "${rule_number} drop insecure outgoing HTTP traffic":
      ensure   => $ensure,
      chain    => 'OUTPUT',
      dport    => 80,
      proto    => tcp,
      action   => reject,
      provider => $provider,
    }
  }
}
