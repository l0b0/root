class logs {
  cron { 'remove old logs':
    command => '/usr/bin/journalctl --vacuum-time="1 week"',
    hour    => fqdn_rand(24, $module_name),
    minute  => fqdn_rand(60, $module_name),
  }
}
