class file_renamer {
  include shell

  package { 'perl-rename':
    ensure => latest,
  }
}
