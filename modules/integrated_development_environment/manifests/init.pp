class integrated_development_environment {
  include window_manager
  include java_development_kit

  $version = '14.1.4'

  class { 'archive::prerequisites': }
  ->
  class { 'idea::ultimate':
    version => $version,
  }->
  notify { "Run `JAVA_HOME=/usr/lib/jvm/*-jdk /opt/idea-${version}/idea-IU-*/bin/idea.sh` and use Tools -> Create Command-line Launcher…": }
}
