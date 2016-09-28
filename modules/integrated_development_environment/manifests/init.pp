class integrated_development_environment {
  include window_manager
  include java_development_kit

  class { 'archive::prerequisites': }
  ->
  class { 'idea::ultimate':
    version  => '2016.1.4',
    build    => '145.2070.6',
    base_url => 'https://download.jetbrains.com/idea',
    timeout  => 600,
  }->
  file { '/usr/local/bin/idea':
    target => '/opt/idea/bin/idea.sh',
  }
}
