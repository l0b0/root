VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "CentOS_6.5_x64"

  config.vm.provision :puppet, :module_path => "modules", :manifest_file => "host.pp"
end
