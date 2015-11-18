class integrated_development_environment {
  include window_manager
  include java_development_kit

  class { 'archive::prerequisites': }
  ->
  class { 'idea::ultimate':
    version => '15.0.1',
    build   => '143.382.35',
    timeout => 600,
  }->
  file { '/usr/local/bin/idea':
    target => '/opt/idea/bin/idea.sh',
  }
}
