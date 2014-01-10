# The baseline for module testing used by Puppet Labs is that each manifest
# should have a corresponding test manifest that declares that class or defined
# type.
#
# Tests are then run by using puppet apply --noop (to check for compilation
# errors and view a log of events) or by fully applying the test in a virtual
# environment (to compare the resulting system state to the desired state).
#
# Learn more about module testing here:
# http://docs.puppetlabs.com/guides/tests_smoke.html
#
  include profiles::repos
  class {'tomcat':
    manage_java => true,
  }

  tomcat::instance {'daniel':
    ensure         => 'present',
    server_port    => '8012',
    http_connector => true,
    http_protocol  => 'HTTP/1.1',
    http_port      => '8081',
    http_addr      => $::ipaddress,
    ajp_connector  => true,
    ajp_protocol   => 'AJP/1.3',
    ajp_port       => '8013',
    ajp_addr       => $::ipaddress,
  }
  tomcat::instance {'brett':
    ensure         => 'present',
    server_port    => '8009',
    http_connector => true,
    http_protocol  => 'HTTP/1.1',
    http_port      => '8080',
    http_addr      => $::ipaddress,
    ajp_connector  => true,
    ajp_protocol   => 'AJP/1.3',
    ajp_port       => '8010',
    ajp_addr       => $::ipaddress,
  }
