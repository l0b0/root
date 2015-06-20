# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "hiera"
  s.version = "1.3.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Puppet Labs"]
  s.date = "2014-06-06"
  s.description = "A pluggable data store for hierarcical data"
  s.email = "info@puppetlabs.com"
  s.executables = ["hiera"]
  s.files = ["bin/hiera"]
  s.homepage = "https://github.com/puppetlabs/hiera"
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.3"
  s.summary = "Light weight hierarchical data store"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json_pure>, [">= 0"])
    else
      s.add_dependency(%q<json_pure>, [">= 0"])
    end
  else
    s.add_dependency(%q<json_pure>, [">= 0"])
  end
end
