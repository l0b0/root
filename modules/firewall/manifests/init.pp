class firewall {
  include ufw
  include ssh_server

  ufw::limit { 'ssh': }

  ufw::deny { 'Insecure HTTP':
    port => 80,
  }
}
