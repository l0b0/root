include browser
include users

resources { 'firewall':
  purge => true,
}
Firewall {
  before  => Class['ssh_throttle::post'],
  require => Class['ssh_throttle::pre'],
}
class { ['ssh_throttle::pre', 'ssh_throttle::post']: }
class { 'firewall': }

if ($::test) {
  include puppet_lint
}
