require 'spec_helper'
describe('tomcat', :type => :class) do
  let(:node) {'test.puppetlabs.vm'}
  let(:facts) { { :ipaddress => '192.168.168.168' } }

  describe 'Install Redhat Tomcat 7' do
    let(:facts) { { :osfamily => 'RedHat' } }
    #let(:params) { { :manage_java => false } }

    it { should contain_class('tomcat::install') }

    it do
      should contain_package('tomcat').with({
        'ensure' => 'present',
        'name' => 'tomcat7',
      })
    end

    context 'with manage_java => true' do
      let(:params) { { :manage_java => true } }

      it { should contain_class('tomcat::java') }

      it do
        should contain_package('java').with({
          'ensure' => 'present',
          'name'   => 'java-1.7.0-openjdk',
        })
      end
    end
  end

  describe 'Attempt Wrong operating system' do
    let(:facts) { { :osfamily => 'Windows' } }

    it do
      expect {
        contain_class('tomcat::params').to raise_error(Puppet::Error, /is not supported/)
      }
    end
  end

  describe 'Attempt to use character instead of integer version number' do
    let(:version) { 'x' }

    it do
      expect {
        contain_class('tomcat::params').to raise_error(Puppet::Error, /Tomcat version must be an integer/)
      }
    end
  end

  describe 'Attempt to use an incorrect version number' do
    let(:version) { '9' }

    it do
      expect {
        contain_class('tomcat::params').to raise_error(Puppet::Error, /Tomcat version must be 6 or 7/)
      }
    end
  end

  describe 'Configure Tomcat 7' do
    let(:facts) { { :osfamily => 'RedHat' } }

   it { should contain_class('tomcat::config') }

   it do
     should contain_user('tomcat').with({
       'ensure' => 'present',
       'name'   => 'tomcat',
       'gid'    => 'tomcat',
       'shell'  => '/sbin/nologin',
     })
   end

   it do
     should contain_group('tomcat').with({
       'ensure' => 'present',
       'name'   => 'tomcat',
     })
   end

   it do
     should contain_file('/var/log/tomcat').with({
       'ensure' => 'directory',
       'path'   => '/var/log/tomcat',
       'owner'  => 'root',
       'group'  => 'root',
       'mode'   => '0600', #should be 0700, but this occurs on the node, not in the catalog
     }).that_requires('Package[tomcat]')
   end

   it do
     should contain_file('catalina.policy').with({
       'ensure' => 'file',
       'path'   => '/opt/tomcat7/conf/catalina.policy',
       'owner'  => 'root',
       'group'  => 'root',
       'mode'   => '0600',
    }).that_requires('Package[tomcat]')
   end
  end
end
