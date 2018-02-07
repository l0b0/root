class packet_analyzer {
  include shell

  package { [
    'tcpdump',
    'wireshark-cli',
    'wireshark-gtk',
  ]:
    ensure => installed,
  }

  warning("Make sure to add Wireshark users to the 'wireshark' group.")
}
