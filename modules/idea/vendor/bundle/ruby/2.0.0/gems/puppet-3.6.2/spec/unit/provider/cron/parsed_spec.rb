#!/usr/bin/env rspec

require 'spec_helper'

describe Puppet::Type.type(:cron).provider(:crontab) do

  let :provider do
    described_class.new(:command => '/bin/true')
  end

  let :resource do
    Puppet::Type.type(:cron).new(
      :minute      => %w{0 15 30 45},
      :hour        => %w{8-18 20-22},
      :monthday    => %w{31},
      :month       => %w{12},
      :weekday     => %w{7},
      :name        => 'basic',
      :command     => '/bin/true',
      :target      => 'root',
      :provider    => provider
    )
  end

  let :resource_special do
    Puppet::Type.type(:cron).new(
      :special => 'reboot',
      :name    => 'special',
      :command => '/bin/true',
      :target  => 'nobody'
    )
  end

  let :resource_sparse do
    Puppet::Type.type(:cron).new(
      :minute => %w{42},
      :target => 'root',
      :name   => 'sparse'
    )
  end

  let :record_special do
    {
      :record_type => :crontab,
      :special     => 'reboot',
      :command     => '/bin/true',
      :on_disk     => true,
      :target      => 'nobody'
    }
  end

  let :record do
    {
      :record_type => :crontab,
      :minute      => %w{0 15 30 45},
      :hour        => %w{8-18 20-22},
      :monthday    => %w{31},
      :month       => %w{12},
      :weekday     => %w{7},
      :special     => :absent,
      :command     => '/bin/true',
      :on_disk     => true,
      :target      => 'root'
    }
  end

  describe "when determining the correct filetype" do
    it "should use the suntab filetype on Solaris" do
      Facter.stubs(:value).with(:osfamily).returns 'Solaris'
      described_class.filetype.should == Puppet::Util::FileType::FileTypeSuntab
    end

    it "should use the aixtab filetype on AIX" do
      Facter.stubs(:value).with(:osfamily).returns 'AIX'
      described_class.filetype.should == Puppet::Util::FileType::FileTypeAixtab
    end

    it "should use the crontab filetype on other platforms" do
      Facter.stubs(:value).with(:osfamily).returns 'Not a real operating system family'
      described_class.filetype.should == Puppet::Util::FileType::FileTypeCrontab
    end
  end

  # I'd use ENV.expects(:[]).with('USER') but this does not work because
  # ENV["USER"] is evaluated at load time.
  describe "when determining the default target" do
    it "should use the current user #{ENV['USER']}", :if => ENV['USER'] do
      described_class.default_target.should == ENV['USER']
    end

    it "should fallback to root", :unless => ENV['USER'] do
      described_class.default_target.should == "root"
    end
  end

  describe "when parsing a record" do
    it "should parse a comment" do
      described_class.parse_line("# This is a test").should == {
        :record_type => :comment,
        :line        => "# This is a test",
      }
    end

    it "should get the resource name of a PUPPET NAME comment" do
      described_class.parse_line('# Puppet Name: My Fancy Cronjob').should == {
        :record_type => :comment,
        :name        => 'My Fancy Cronjob',
        :line        => '# Puppet Name: My Fancy Cronjob',
      }
    end

    it "should ignore blank lines" do
      described_class.parse_line('').should == {:record_type => :blank, :line => ''}
      described_class.parse_line(' ').should == {:record_type => :blank, :line => ' '}
      described_class.parse_line("\t").should == {:record_type => :blank, :line => "\t"}
      described_class.parse_line("  \t ").should == {:record_type => :blank, :line => "  \t "}
    end

    it "should extract environment assignments" do
      # man 5 crontab: MAILTO="" with no value can be used to surpress sending
      # mails at all
      described_class.parse_line('MAILTO=""').should == {:record_type => :environment, :line => 'MAILTO=""'}
      described_class.parse_line('FOO=BAR').should == {:record_type => :environment, :line => 'FOO=BAR'}
      described_class.parse_line('FOO_BAR=BAR').should == {:record_type => :environment, :line => 'FOO_BAR=BAR'}
    end

    it "should extract a cron entry" do
      described_class.parse_line('* * * * * /bin/true').should == {
        :record_type => :crontab,
        :hour        => :absent,
        :minute      => :absent,
        :month       => :absent,
        :weekday     => :absent,
        :monthday    => :absent,
        :special     => :absent,
        :command     => '/bin/true'
      }
      described_class.parse_line('0,15,30,45 8-18,20-22 31 12 7 /bin/true').should == {
        :record_type => :crontab,
        :minute      => %w{0 15 30 45},
        :hour        => %w{8-18 20-22},
        :monthday    => %w{31},
        :month       => %w{12},
        :weekday     => %w{7},
        :special     => :absent,
        :command     => '/bin/true'
      }
      # A percent sign will cause the rest of the string to be passed as
      # standard input and will also act as a newline character. Not sure
      # if puppet should convert % to a \n as the command property so the
      # test covers the current behaviour: Do not do any conversions
      described_class.parse_line('0 22 * * 1-5   mail -s "It\'s 10pm" joe%Joe,%%Where are your kids?%').should == {
        :record_type => :crontab,
        :minute      => %w{0},
        :hour        => %w{22},
        :monthday    => :absent,
        :month       => :absent,
        :weekday     => %w{1-5},
        :special     => :absent,
        :command     => 'mail -s "It\'s 10pm" joe%Joe,%%Where are your kids?%'
      }
    end

    describe "it should support special strings" do
      ['reboot','yearly','anually','monthly', 'weekly', 'daily', 'midnight', 'hourly'].each do |special|
        it "should support @#{special}" do
          described_class.parse_line("@#{special} /bin/true").should == {
            :record_type => :crontab,
            :hour        => :absent,
            :minute      => :absent,
            :month       => :absent,
            :weekday     => :absent,
            :monthday    => :absent,
            :special     => special,
            :command     => '/bin/true'
          }
        end
      end
    end
  end

  describe ".instances" do
    before :each do
      described_class.stubs(:default_target).returns 'foobar'
    end

    describe "on linux" do
      before do
        Facter.stubs(:value).with(:osfamily).returns 'Linux'
        Facter.stubs(:value).with(:operatingsystem)
      end

      it "should be empty if user has no crontab" do
        # `crontab...` does only capture stdout here. On vixie-cron-4.1
        # STDERR shows "no crontab for foobar" but stderr is ignored as
        # well as the exitcode.
        described_class.target_object('foobar').expects(:`).with('crontab -u foobar -l 2>/dev/null').returns ""
        described_class.instances.should be_empty
      end

      it "should be empty if user is not present" do
        # `crontab...` does only capture stdout. On vixie-cron-4.1
        # STDERR shows "crontab:  user `foobar' unknown" but stderr is
        # ignored as well as the exitcode
        described_class.target_object('foobar').expects(:`).with('crontab -u foobar -l 2>/dev/null').returns ""
        described_class.instances.should be_empty
      end

      it "should be able to create records from not-managed records" do
        described_class.expects(:target_object).returns File.new(my_fixture('simple'))
        parameters = described_class.instances.map do |p|
          h = {:name => p.get(:name)}
          Puppet::Type.type(:cron).validproperties.each do |property|
            h[property] = p.get(property)
          end
          h
        end

        expect(parameters[0][:name]).to match(%r{unmanaged:\$HOME/bin/daily.job_>>_\$HOME/tmp/out_2>&1-\d+})
        expect(parameters[0][:minute]).to eq(['5'])
        expect(parameters[0][:hour]).to eq(['0'])
        expect(parameters[0][:weekday]).to eq(:absent)
        expect(parameters[0][:month]).to eq(:absent)
        expect(parameters[0][:monthday]).to eq(:absent)
        expect(parameters[0][:special]).to eq(:absent)
        expect(parameters[0][:command]).to match(%r{\$HOME/bin/daily.job >> \$HOME/tmp/out 2>&1})
        expect(parameters[0][:ensure]).to eq(:present)
        expect(parameters[0][:environment]).to eq(:absent)
        expect(parameters[0][:user]).to eq(:absent)

        expect(parameters[1][:name]).to match(%r{unmanaged:\$HOME/bin/monthly-\d+})
        expect(parameters[1][:minute]).to eq(['15'])
        expect(parameters[1][:hour]).to eq(['14'])
        expect(parameters[1][:weekday]).to eq(:absent)
        expect(parameters[1][:month]).to eq(:absent)
        expect(parameters[1][:monthday]).to eq(['1'])
        expect(parameters[1][:special]).to eq(:absent)
        expect(parameters[1][:command]).to match(%r{\$HOME/bin/monthly})
        expect(parameters[1][:ensure]).to eq(:present)
        expect(parameters[1][:environment]).to eq(:absent)
        expect(parameters[1][:user]).to eq(:absent)
        expect(parameters[1][:target]).to eq('foobar')
      end

      it "should be able to parse puppet manged cronjobs" do
        described_class.expects(:target_object).returns File.new(my_fixture('managed'))
        described_class.instances.map do |p|
          h = {:name => p.get(:name)}
          Puppet::Type.type(:cron).validproperties.each do |property|
            h[property] = p.get(property)
          end
          h
        end.should == [
          {
            :name        => 'real_job',
            :minute      => :absent,
            :hour        => :absent,
            :weekday     => :absent,
            :month       => :absent,
            :monthday    => :absent,
            :special     => :absent,
            :command     => '/bin/true',
            :ensure      => :present,
            :environment => :absent,
            :user        => :absent,
            :target      => 'foobar'
          },
          {
            :name        => 'complex_job',
            :minute      => :absent,
            :hour        => :absent,
            :weekday     => :absent,
            :month       => :absent,
            :monthday    => :absent,
            :special     => 'reboot',
            :command     => '/bin/true >> /dev/null 2>&1',
            :ensure      => :present,
            :environment => [
              'MAILTO=foo@example.com',
              'SHELL=/bin/sh'
            ],
            :user        => :absent,
            :target      => 'foobar'
          }
        ]
      end
    end
  end

  describe ".match" do
    describe "normal records" do
      it "should match when all fields are the same" do
        described_class.match(record,{resource[:name] => resource}).must == resource
      end

      {
        :minute      => %w{0 15 31 45},
        :hour        => %w{8-18},
        :monthday    => %w{30 31},
        :month       => %w{12 23},
        :weekday     => %w{4},
        :command     => '/bin/false',
        :target      => 'nobody'
      }.each_pair do |field, new_value|
        it "should not match a record when #{field} does not match" do
          record[field] = new_value
          described_class.match(record,{resource[:name] => resource}).must be_false
        end
      end
    end

    describe "special records" do
      it "should match when all fields are the same" do
        described_class.match(record_special,{resource_special[:name] => resource_special}).must == resource_special
      end

      {
        :special => 'monthly',
        :command => '/bin/false',
        :target  => 'root'
      }.each_pair do |field, new_value|
        it "should not match a record when #{field} does not match" do
          record_special[field] = new_value
          described_class.match(record_special,{resource_special[:name] => resource_special}).must be_false
        end
      end
    end

    describe "with a resource without a command" do
      it "should not raise an error" do
        expect { described_class.match(record,{resource_sparse[:name] => resource_sparse}) }.to_not raise_error
      end
    end

  end
end
