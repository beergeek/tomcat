#
define tomcat::instance (
  $ensure               = 'present',
  $server_port          = '8009',
  $http_connector       = true,
  $http_protocol        = 'HTTP/1.1',
  $http_port            = '8080',
  $http_addr            = $::ipaddress,
  $ajp_connector        = true,
  $ajp_protocol         = 'AJP/1.3',
  $ajp_port             = '8009',
  $ajp_addr             = $::ipaddress,
  $dsun_java2d_opengl   = "false",
  $djava_awt_headless   = "true",
  $java_xmx             = "512m",
  $java_xx_maxpermsize  = "512m",
) {

  include tomcat::params
  $t_dir = "${tomcat::params::tomcat_dir}/${name}"

  #use magic $name to get title of resource
  $instance = $name

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  file {[$t_dir,"${t_dir}/bin","${t_dir}/conf","${t_dir}/lib","${t_dir}/temp","${t_dir}/webapps"]:
    ensure => directory,
  }

  file {["${t_dir}/logs","${t_dir}/pid"]:
    ensure => directory,
    owner  => $tomcat::params::tomcat_user,
    group  => $tomcat::params::tomcat_grp,
  }

  file {"${t_dir}/conf/server.xml":
    ensure  => file,
    content => template('tomcat/server.xml.erb'),
    notify  => Service["tomcat-${name}"],
  }

  file {"${t_dir}/conf/web.xml":
    ensure  => file,
    content => template('tomcat/web.xml.erb'),
    notify  => Service["tomcat-${name}"],
  }

  if $http_connector {
    tomcat::connector{"http-${http_port}-${name}":
      ensure   => $ensure,
      instance => $name,
      protocol => $http_protocol,
      port     => $http_port,
      address  => $http_address,
    }
  }

  if $ajp_connector {
    tomcat::connector{"ajp-${ajp_port}-${name}":
      ensure   => $ensure,
      instance => $name,
      protocol => $ajp_protocol,
      port     => $ajp_port,
      address  => $ajp_address,
    }
  }

  file {"/etc/init.d/tomcat-${name}":
    ensure  => file,
    mode    => '0744',
    content => template('tomcat/initd_script.erb'),
  }

  service {"tomcat-${name}":
    ensure  => running,
    enable  => true,
    require => File["/etc/init.d/tomcat-${name}"],
  }
}
