class x_server_clipboard_cli {
  include shell

  package { 'xclip':
    ensure => installed,
  }
}
