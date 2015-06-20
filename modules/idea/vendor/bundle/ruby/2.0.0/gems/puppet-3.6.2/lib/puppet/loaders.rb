module Puppet
  module Pops
    require 'puppet/pops/loaders'

    module Loader
      require 'puppet/pops/loader/loader'
      require 'puppet/pops/loader/base_loader'
      require 'puppet/pops/loader/gem_support'
      require 'puppet/pops/loader/module_loaders'
      require 'puppet/pops/loader/dependency_loader'
      require 'puppet/pops/loader/null_loader'
      require 'puppet/pops/loader/static_loader'
      require 'puppet/pops/loader/ruby_function_instantiator'
      require 'puppet/pops/loader/ruby_legacy_function_instantiator'
      require 'puppet/pops/loader/loader_paths'
      require 'puppet/pops/loader/simple_environment_loader'
    end
  end

end
