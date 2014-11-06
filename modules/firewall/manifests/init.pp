class firewall {
  include ufw

  ufw::limit { 'ssh': }
}
