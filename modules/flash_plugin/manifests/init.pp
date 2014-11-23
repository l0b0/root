class flash_plugin {
  include browser

  package { 'flashplugin':
    ensure => latest,
  }
}
