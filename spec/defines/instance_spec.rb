require 'spec_helper'
describe('tomcat::instance') do
  let(:node) {'test.puppetlabs.vm'}
  let(:facts) { { :ipaddress => '192.168.168.168' } }
  let(:title) { 'test' }
  let(:name) { 'test' }

  describe 'New Instance' do
    let(:facts) { { :osfamily => 'RedHat' } }

    it { should contain_tomcat__connector('http-8080-test') }

    it do
      should contain_file('tomcat::params::tomcat_dir').with({
        'ensure' => 'directory',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0644',
      })
    end
  end
end
