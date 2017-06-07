source 'https://rubygems.org'
puppetversion = ENV.key?('PUPPET_VERSION') ? "= #{ENV['PUPPET_VERSION']}" : ['>= 2.7']

gem 'puppet', puppetversion
 
group :test do
  gem 'rake', '>= 11.1.1'
  gem 'rspec', '>= 3.4.0'
  gem 'rspec-puppet', '>= 2.3.2'
  gem 'puppet-lint', '>= 1.1.0'
end
