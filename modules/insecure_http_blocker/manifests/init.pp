class insecure_http_blocker {
  $firewall_index_start = 100
  $http_allowed_hosts = [
    '10.0.0.0/8',
    '127.0.0.0/8',
    '172.16.0.0/12',
    '192.168.0.0/16',
    'clients1.google.com',
    'commercial.ocsp.identrust.com',
    'database.clamav.net',
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

  $http_allowed_host_count = size($http_allowed_hosts)
  $log_entry_index = $firewall_index_start + $http_allowed_host_count
  $drop_entry_index = $log_entry_index + 1

  $http_allowed_hosts.each |Integer $index, String $host| {
    $rule_number = $firewall_index_start + $index
    firewall { join([$rule_number, 'allow outgoing HTTP traffic to OCSP responders'], ' '):
      chain       => 'OUTPUT',
      destination => $host,
      dport       => 80,
      proto       => tcp,
      action      => accept,
    }
  }

  firewall { "${log_entry_index} log insecure outgoing HTTP traffic":
    chain      => 'OUTPUT',
    dport      => 80,
    proto      => tcp,
    jump       => 'LOG',
    log_level  => debug,
    log_prefix => 'outgoing HTTP traffic ',
    log_uid    => true,
  } -> firewall { "${drop_entry_index} drop insecure outgoing HTTP traffic":
    chain  => 'OUTPUT',
    dport  => 80,
    proto  => tcp,
    action => reject,
  }
}
