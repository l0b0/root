class integrated_development_environment {
  include window_manager
  include java_development_kit

  class { 'archive::prerequisites':
  } -> class { 'idea::ultimate':
    version  => '2018.1',
    base_url => 'https://download.jetbrains.com/idea',
    timeout  => 3600,
  } -> file { '/usr/local/bin/idea':
    target => '/opt/idea/bin/idea.sh',
  }
}
