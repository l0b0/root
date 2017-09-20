class packet_analyzer {
  include shell

  package { [
    'wireshark-cli',
    'wireshark-gtk',
  ]:
    ensure => latest,
  }

  warning("Make sure to add Wireshark users to the 'wireshark' group.")
}
