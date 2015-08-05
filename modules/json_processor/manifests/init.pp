class json_processor {
  include shell

  package { 'jq':
    ensure => latest,
  }
}
