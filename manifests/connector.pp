#
define tomcat::connector (
  $ensure         = 'present',
  $instance       = $name,
  $port,
  $owner          = $tomcat::params::tomcat_user,
  $group          = $tomcat::params::tomcat_grp,
  $protocol       = '/HTTP/1.1',
  $uri_encoding   = 'UTF-8',
  $address        = $::ipaddress,
  $timeout        = '20000',
  $redirect_port  = '8443',
  $scheme         = false,
  $options        = [],
) {

  file {"${tomcat::params::tomcat_dir}/${instance}/conf/connector-${name}.xml":
    ensure  => $ensure,
    owner   => $owner,
    group   => $group,
    mode    => '0644',
    content => template('tomcat/connector.xml.erb'),
  }

} 
