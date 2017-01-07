require 'rake'
require 'rspec/core/rake_task'
require 'puppet-lint/tasks/puppet-lint'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/*/*_spec.rb'
end

PuppetLint::RakeTask.new :lint do |configuration|
  configuration.relative = true
  configuration.ignore_paths = [
      'pkg/**/*',
      'spec/**/*',
  ]
end

task :default => [:spec, :lint]
