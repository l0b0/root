require 'spec_helper'
require 'json'

require 'puppet/module_tool/applications'
require 'puppet_spec/modules'

describe Puppet::ModuleTool::Applications::Unpacker do
  include PuppetSpec::Files

  let(:target)      { tmpdir("unpacker") }
  let(:module_name) { 'myusername-mytarball' }
  let(:filename)    { tmpdir("module") + "/module.tar.gz" }
  let(:working_dir) { tmpdir("working_dir") }

  before :each do
    Puppet.settings[:module_working_dir] = working_dir
  end

  it "should attempt to untar file to temporary location" do
    untar = mock('Tar')
    untar.expects(:unpack).with(filename, anything()) do |src, dest, _|
      FileUtils.mkdir(File.join(dest, 'extractedmodule'))
      File.open(File.join(dest, 'extractedmodule', 'metadata.json'), 'w+') do |file|
        file.puts JSON.generate('name' => module_name, 'version' => '1.0.0')
      end
      true
    end

    Puppet::ModuleTool::Tar.expects(:instance).returns(untar)

    Puppet::ModuleTool::Applications::Unpacker.run(filename, :target_dir => target)
    File.should be_directory(File.join(target, 'mytarball'))
  end
end
