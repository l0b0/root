class perl_gnu_readline_library_interface {
  include shell

  package { 'perl-term-readline-gnu':
    ensure => latest,
  }
}
