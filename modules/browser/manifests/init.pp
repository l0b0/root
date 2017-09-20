class browser {
  include window_manager

  package { 'firefox':
    ensure => latest,
  }

  $firewall_index_start = 100
  $ocsp_hosts = [
    'ocsp.comodoca.com',
    'ocsp.digicert.com',
    'ocsp.int-x3.letsencrypt.org',
    'ocsp.msocsp.com',
    'ocsp.sca1b.amazontrust.com',
    'ocsp.usertrust.com',
    'ocsp2.globalsign.com',
  ]

  $ocsp_host_count = size($ocsp_hosts)

  $ocsp_hosts.each |Integer $index, String $host| {
    firewall { join([$firewall_index_start + $index, 'allow outgoing HTTP traffic to OCSP responders'], ' '):
      chain       => 'OUTPUT',
      destination => $host,
      dport       => 80,
      proto       => tcp,
      action      => accept,
    }
  }

  firewall { join([$firewall_index_start + $ocsp_host_count, 'log insecure outgoing HTTP traffic'], ' '):
    chain      => 'OUTPUT',
    dport      => 80,
    proto      => tcp,
    jump       => 'LOG',
    log_level  => debug,
    log_prefix => 'outgoing HTTP traffic ',
    log_uid    => true,
  } -> firewall { join([$firewall_index_start + $ocsp_host_count + 1, 'drop insecure outgoing HTTP traffic'], ' '):
    chain  => 'OUTPUT',
    dport  => 80,
    proto  => tcp,
    action => reject,
  }
}
