class firewall {
  include ufw
  include ssh_server

  ufw::limit { 'ssh': }
}
