VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'terrywang/archlinux'

  config.vm.provision 'shell', :path => 'test/setup-dependencies.sh'
  config.vm.provision :reload
  config.vm.provision :puppet do |puppet|
    puppet.environment_path = 'environments'
    puppet.environment = 'production'
    puppet.manifests_path = 'manifests'
    puppet.manifest_file = 'host.pp'
    puppet.module_path = 'modules'
    puppet.options = '--detailed-exitcodes --verbose --debug'
    puppet.facter = {
      :test => true
    }
  end
end
