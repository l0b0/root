class text_editor {
  include shell

  package { 'vim':
    ensure => latest,
  } -> file { '/etc/vimrc':
    source => "puppet:///modules/${module_name}/vimrc",
    mode   => '0644',
  }
}
