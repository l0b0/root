require 'spec_helper'

describe 'systemd::dropin_file' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }

        let(:title) { 'test.conf' }

        let(:params) {{
          :unit    => 'test.service',
          :content => 'random stuff'
        }}

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to create_file("/etc/systemd/system/#{params[:unit]}.d").with(
          :ensure  => 'directory',
        ) }

        it { is_expected.to create_file("/etc/systemd/system/#{params[:unit]}.d/#{title}").with(
          :ensure  => 'file',
          :content => /#{params[:content]}/,
          :mode    => '0444'
        ) }

        it { is_expected.to create_file("/etc/systemd/system/#{params[:unit]}.d/#{title}").that_notifies('Class[systemd::systemctl::daemon_reload]') }

        context 'with a bad unit type' do
          let(:title) { 'test.badtype' }

          it {
            expect{
              is_expected.to compile.with_all_deps
            }.to raise_error(/expects a match for Systemd::Dropin/)
          }
        end
      end
    end
  end
end
