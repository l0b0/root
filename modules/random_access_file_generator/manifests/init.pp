class random_access_file_generator {
  include shell

  package { 'fortune-mod':
    ensure => latest,
  }
}
