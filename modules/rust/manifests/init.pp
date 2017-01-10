class rust {
  package { 'rustup':
    ensure => latest,
  } ~>
  exec { [
    '/usr/bin/rustup toolchain install stable',
    '/usr/bin/rustup default stable',
    '/usr/bin/rustup component add rust-src'
  ]:
    refreshonly => true,
  }
}
