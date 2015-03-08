VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "terrywang/archlinux"

  config.vm.provision "shell", path: "test/setup-dependencies.sh"
  config.vm.provision :reload
  config.vm.provision :puppet do |puppet|
    puppet.module_path = "modules"
    puppet.manifest_file = "host.pp"
    puppet.options = "--detailed-exitcodes --verbose --debug"
    puppet.facter = {
      "test" => true
    }
  end
end
