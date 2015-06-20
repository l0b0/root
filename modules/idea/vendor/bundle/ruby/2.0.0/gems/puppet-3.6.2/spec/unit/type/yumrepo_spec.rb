require 'spec_helper'
require 'puppet'

shared_examples_for "a yumrepo parameter that can be absent" do |param|
  it "can be set as :absent" do
    described_class.new(:name => 'puppetlabs', param => :absent)
  end
  it "can be set as \"absent\"" do
    described_class.new(:name => 'puppetlabs', param => 'absent')
  end
end

shared_examples_for "a yumrepo parameter that expects a boolean parameter" do |param|
  valid_values = %w[True False 0 1 No Yes]

  valid_values.each do |value|
    it "accepts a valid value of #{value}" do
      instance = described_class.new(:name => 'puppetlabs', param => value)
      expect(instance[param]).to eq value
    end
    it "accepts #{value} downcased to #{value.downcase}" do
      instance = described_class.new(:name => 'puppetlabs', param => value.downcase)
      expect(instance[param]).to eq value.downcase
    end
  end

  it "rejects invalid boolean values" do
    expect {
      described_class.new(:name => 'puppetlabs', param => 'flase')
    }.to raise_error(Puppet::ResourceError, /Parameter #{param} failed/)
  end
end

shared_examples_for "a yumrepo parameter that accepts a single URL" do |param|
  it "can accept a single URL" do
    described_class.new(
      :name => 'puppetlabs',
      param => 'http://localhost/yumrepos'
    )
  end

  it "fails if an invalid URL is provided" do
    expect {
      described_class.new(
        :name => 'puppetlabs',
        param => "that's no URL!"
      )
    }.to raise_error(Puppet::ResourceError, /Parameter #{param} failed/)
  end

  it "fails if a valid URL uses an invalid URI scheme" do
    expect {
      described_class.new(
        :name => 'puppetlabs',
        param => 'ldap://localhost/yumrepos'
      )
    }.to raise_error(Puppet::ResourceError, /Parameter #{param} failed/)
  end
end

shared_examples_for "a yumrepo parameter that accepts multiple URLs" do |param|
  it "can accept multiple URLs" do
    described_class.new(
      :name => 'puppetlabs',
      param => 'http://localhost/yumrepos http://localhost/more-yumrepos'
    )
  end

  it "fails if multiple URLs are given and one is invalid" do
    expect {
      described_class.new(
        :name => 'puppetlabs',
        param => "http://localhost/yumrepos That's no URL!"
      )
    }.to raise_error(Puppet::ResourceError, /Parameter #{param} failed/)
  end
end

describe Puppet::Type.type(:yumrepo) do
  it "has :name as its namevar" do
    expect(described_class.key_attributes).to eq [:name]
  end

  describe "validating" do

    describe "name" do
      it "is a valid parameter" do
        instance = described_class.new(:name => 'puppetlabs')
        expect(instance.name).to eq 'puppetlabs'
      end
    end

    describe "target" do
      it_behaves_like "a yumrepo parameter that can be absent", :target
    end

    describe "descr" do
      it_behaves_like "a yumrepo parameter that can be absent", :descr
    end

    describe "mirrorlist" do
      it_behaves_like "a yumrepo parameter that accepts a single URL", :mirrorlist
      it_behaves_like "a yumrepo parameter that can be absent", :mirrorlist
    end

    describe "baseurl" do
      it_behaves_like "a yumrepo parameter that can be absent", :baseurl
      it_behaves_like "a yumrepo parameter that accepts a single URL", :baseurl
      it_behaves_like "a yumrepo parameter that accepts multiple URLs", :baseurl
    end

    describe "enabled" do
      it_behaves_like "a yumrepo parameter that expects a boolean parameter", :enabled
      it_behaves_like "a yumrepo parameter that can be absent", :enabled
    end

    describe "gpgcheck" do
      it_behaves_like "a yumrepo parameter that expects a boolean parameter", :gpgcheck
      it_behaves_like "a yumrepo parameter that can be absent", :gpgcheck
    end

    describe "repo_gpgcheck" do
      it_behaves_like "a yumrepo parameter that expects a boolean parameter", :repo_gpgcheck
      it_behaves_like "a yumrepo parameter that can be absent", :repo_gpgcheck
    end

    describe "gpgkey" do
      it_behaves_like "a yumrepo parameter that can be absent", :gpgkey
      it_behaves_like "a yumrepo parameter that accepts a single URL", :gpgkey
      it_behaves_like "a yumrepo parameter that accepts multiple URLs", :gpgkey
    end

    describe "include" do
      it_behaves_like "a yumrepo parameter that can be absent", :include
      it_behaves_like "a yumrepo parameter that accepts a single URL", :include
    end

    describe "exclude" do
      it_behaves_like "a yumrepo parameter that can be absent", :exclude
    end

    describe "includepkgs" do
      it_behaves_like "a yumrepo parameter that can be absent", :includepkgs
    end

    describe "enablegroups" do
      it_behaves_like "a yumrepo parameter that expects a boolean parameter", :enablegroups
      it_behaves_like "a yumrepo parameter that can be absent", :enablegroups
    end

    describe "failovermethod" do

      %w[roundrobin priority].each do |value|
        it "accepts a value of #{value}" do
          described_class.new(:name => "puppetlabs", :failovermethod => value)
        end
      end

      it "raises an error if an invalid value is given" do
        expect {
          described_class.new(:name => "puppetlabs", :failovermethod => "notavalidvalue")
        }.to raise_error(Puppet::ResourceError, /Parameter failovermethod failed/)
      end

      it_behaves_like "a yumrepo parameter that can be absent", :failovermethod
    end

    describe "keepalive" do
      it_behaves_like "a yumrepo parameter that expects a boolean parameter", :keepalive
      it_behaves_like "a yumrepo parameter that can be absent", :keepalive
    end

    describe "http_caching" do
      %w[packages all none].each do |value|
        it "accepts a valid value of #{value}" do
          described_class.new(:name => 'puppetlabs', :http_caching => value)
        end
      end

      it "rejects invalid values" do
        expect {
          described_class.new(:name => 'puppetlabs', :http_caching => 'yes')
        }.to raise_error(Puppet::ResourceError, /Parameter http_caching failed/)
      end

      it_behaves_like "a yumrepo parameter that can be absent", :http_caching
    end

    describe "timeout" do
      it_behaves_like "a yumrepo parameter that can be absent", :timeout
    end

    describe "metadata_expire" do
      it_behaves_like "a yumrepo parameter that can be absent", :metadata_expire
    end

    describe "protect" do
      it_behaves_like "a yumrepo parameter that expects a boolean parameter", :protect
      it_behaves_like "a yumrepo parameter that can be absent", :protect
    end

    describe "priority" do
      it_behaves_like "a yumrepo parameter that can be absent", :priority
    end

    describe "proxy" do
      it_behaves_like "a yumrepo parameter that can be absent", :proxy
      it_behaves_like "a yumrepo parameter that accepts a single URL", :proxy
    end

    describe "proxy_username" do
      it_behaves_like "a yumrepo parameter that can be absent", :proxy_username
    end

    describe "proxy_password" do
      it_behaves_like "a yumrepo parameter that can be absent", :proxy_password
    end

    describe "s3_enabled" do
      it_behaves_like "a yumrepo parameter that expects a boolean parameter", :s3_enabled
      it_behaves_like "a yumrepo parameter that can be absent", :s3_enabled
    end

    describe "skip_if_unavailable" do
      it_behaves_like "a yumrepo parameter that expects a boolean parameter", :skip_if_unavailable
      it_behaves_like "a yumrepo parameter that can be absent", :skip_if_unavailable
    end

    describe "sslcacert" do
      it_behaves_like "a yumrepo parameter that can be absent", :sslcacert
    end

    describe "sslverify" do
      it_behaves_like "a yumrepo parameter that expects a boolean parameter", :sslverify
      it_behaves_like "a yumrepo parameter that can be absent", :sslverify
    end

    describe "sslclientcert" do
      it_behaves_like "a yumrepo parameter that can be absent", :sslclientcert
    end

    describe "sslclientkey" do
      it_behaves_like "a yumrepo parameter that can be absent", :sslclientkey
    end

    describe "metalink" do
      it_behaves_like "a yumrepo parameter that can be absent", :metalink
      it_behaves_like "a yumrepo parameter that accepts a single URL", :metalink
    end
  end
end
