class java_development_kit {
  $java_environment_name = 'java-8-openjdk'

  package { 'jdk8-openjdk':
    ensure => latest,
  } ~> exec { "/usr/bin/archlinux-java set ${java_environment_name}":
    unless => "/usr/bin/test \"$(archlinux-java get)\" = '${java_environment_name}'",
  }
}
