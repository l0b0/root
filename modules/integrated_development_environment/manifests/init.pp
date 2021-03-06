class integrated_development_environment {
  include window_manager
  include java_development_kit

  class { 'archive::prerequisites':
  } -> class { 'idea::ultimate':
    version  => '2018.1.3',
    base_url => 'https://download.jetbrains.com/idea',
    timeout  => 3600,
  } -> file { '/usr/local/bin/idea':
    target => '/opt/idea/bin/idea.sh',
  }

  file { '/etc/security/limits.d/99-users-nofile.conf':
    ensure => present,
    source => "puppet:///modules/${module_name}/users-nofile.conf",
    mode   => '0644',
  }
}
