require 'spec_helper'
require 'puppet_spec/files'
require 'puppet/pops'
require 'puppet/loaders'

describe 'FileBased module loader' do
  include PuppetSpec::Files

  let(:static_loader) { Puppet::Pops::Loader::StaticLoader.new() }
  let(:loaders) { Puppet::Pops::Loaders.new(Puppet::Node::Environment.create(:testing, [])) }

  it 'can load a 4x function API ruby function in global name space' do
    module_dir = dir_containing('testmodule', {
      'lib' => {
        'puppet' => {
          'functions' => {
            'foo4x.rb' => <<-CODE
               Puppet::Functions.create_function(:foo4x) do
                 def foo4x()
                   'yay'
                 end
               end
            CODE
          }
            }
          }
        })

    module_loader = Puppet::Pops::Loader::ModuleLoaders::FileBased.new(static_loader, loaders, 'testmodule', module_dir, 'test1')
    function = module_loader.load_typed(typed_name(:function, 'foo4x')).value

    expect(function.class.name).to eq('foo4x')
    expect(function.is_a?(Puppet::Functions::Function)).to eq(true)
  end

  it 'can load a 4x function API ruby function in qualified name space' do
    module_dir = dir_containing('testmodule', {
      'lib' => {
        'puppet' => {
          'functions' => {
            'testmodule' => {
              'foo4x.rb' => <<-CODE
                 Puppet::Functions.create_function('testmodule::foo4x') do
                   def foo4x()
                     'yay'
                   end
                 end
              CODE
              }
            }
          }
      }})

    module_loader = Puppet::Pops::Loader::ModuleLoaders::FileBased.new(static_loader, loaders, 'testmodule', module_dir, 'test1')
    function = module_loader.load_typed(typed_name(:function, 'testmodule::foo4x')).value
    expect(function.class.name).to eq('testmodule::foo4x')
    expect(function.is_a?(Puppet::Functions::Function)).to eq(true)
  end

  it 'makes parent loader win over entries in child' do
    module_dir = dir_containing('testmodule', {
      'lib' => { 'puppet' => { 'functions' => { 'testmodule' => {
        'foo.rb' => <<-CODE
           Puppet::Functions.create_function('testmodule::foo') do
             def foo()
               'yay'
             end
           end
        CODE
      }}}}})
    module_loader = Puppet::Pops::Loader::ModuleLoaders::FileBased.new(static_loader, loaders, 'testmodule', module_dir, 'test1')

    module_dir2 = dir_containing('testmodule2', {
      'lib' => { 'puppet' => { 'functions' => { 'testmodule2' => {
        'foo.rb' => <<-CODE
           raise "should not get here"
        CODE
      }}}}})
    module_loader2 = Puppet::Pops::Loader::ModuleLoaders::FileBased.new(module_loader, loaders, 'testmodule2', module_dir2, 'test2')

    function = module_loader2.load_typed(typed_name(:function, 'testmodule::foo')).value

    expect(function.class.name).to eq('testmodule::foo')
    expect(function.is_a?(Puppet::Functions::Function)).to eq(true)
  end

  context 'when delegating 3x to 4x' do
    before(:each) { Puppet[:biff] = true }

    it 'can load a 3x function API ruby function in global name space' do
      module_dir = dir_containing('testmodule', {
        'lib' => {
          'puppet' => {
            'parser' => {
              'functions' => {
                'foo3x.rb' => <<-CODE
                  Puppet::Parser::Functions::newfunction(
                    :foo3x, :type => :rvalue,
                    :arity => 1
                  ) do |args|
                    args[0]
                  end
                CODE
              }
              }
            }
        }})

     module_loader = Puppet::Pops::Loader::ModuleLoaders::FileBased.new(static_loader, loaders, 'testmodule', module_dir, 'test1')
     function = module_loader.load_typed(typed_name(:function, 'foo3x')).value
     expect(function.class.name).to eq('foo3x')
     expect(function.is_a?(Puppet::Functions::Function)).to eq(true)
    end
  end

  def typed_name(type, name)
    Puppet::Pops::Loader::Loader::TypedName.new(type, name)
  end
end
