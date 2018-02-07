class fonts {
  include display_server

  package { [
    'adobe-source-code-pro-fonts',
    'adobe-source-sans-pro-fonts',
    'adobe-source-serif-pro-fonts',
    'ttf-bitstream-vera',
    'ttf-dejavu',
    'ttf-droid',
    'ttf-freefont',
    'ttf-inconsolata',
    'ttf-liberation',
    'ttf-ubuntu-font-family',
  ]:
    ensure => installed,
  }
}
