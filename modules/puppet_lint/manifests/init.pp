class puppet_lint {
  package { 'puppet-lint':
    ensure   => '1.1.0',
    provider => 'gem',
  }->file { '/usr/bin/puppet-lint':
    mode => '0755',
  }
}
