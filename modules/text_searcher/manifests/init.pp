class text_searcher {
  include shell

  package { 'ripgrep':
    ensure => installed,
  }
}
