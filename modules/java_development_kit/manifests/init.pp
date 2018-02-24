class java_development_kit {
  $java_environment_name = 'java-9-openjdk'

  package { 'jdk9-openjdk':
    ensure => installed,
  } ~> exec { "/usr/bin/archlinux-java set ${java_environment_name}":
    unless => "/usr/bin/test \"$(archlinux-java get)\" = '${java_environment_name}'",
  }
}
