class firewall {
  include ufw
  include sshd

  ufw::limit { 'ssh': }
}
