class packet_analyzer {
  include shell

  package { ['wireshark-cli', 'wireshark-gtk']:
    ensure => latest,
  }
}
