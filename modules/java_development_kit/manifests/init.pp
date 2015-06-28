class java_development_kit {
  package { ['jdk8-openjdk']:
    ensure => latest,
  }
  exec { '/usr/bin/archlinux-java set java-8-jdk':
    subscribe => Package['jdk8-openjdk'],
  }
}
