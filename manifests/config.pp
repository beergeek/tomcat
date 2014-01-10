class tomcat::config (
  $server_loader              = undef,
  $shared_loader              = undef,
  $handler_level              = 'FINE',
  $logger_level               = 'INFO',
  $custom_logging             = undef,
  $custom_catalina_policy     = undef,
  $custom_catalina_properties = undef,
) inherits tomcat::params {

  File {
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    require => Package['tomcat'],
    notify  => Service['tomcat'],
  }

  user {'tomcat':
    ensure  => present,
    name    => $tomcat::params::tomcat_user,
    gid     => $tomcat::params::tomcat_grp,
    shell   => '/sbin/nologin',
    comment => 'Tomcat user created by Puppet',
  }

  group {'tomcat':
    ensure => present,
    name   => $tomcat::params::tomcat_grp,
  }

  file { '/var/log/tomcat':
    ensure  => directory,
    require => undef,
    notify  => undef,
  }

  if $custom_catalina_policy {
    $catalina_policy = undef
  }else {
    $catalina_policy = "template('tomcat/catalina.policy.erb')"
  }

  file {'catalina.policy':
    ensure  => file,
    path    => $tomcat::params::catalina_policy_path,
    content => $catalina_policy,
    source  => $custom_catalina_policy,
  }

  if $custom_catalina_properties {
    $catalina_properties = undef
  }else {
    $catalina_properties = "template('tomcat/catalina.properties.erb')"
  }

  file {'catalina.properties':
    ensure  => file,
    path    => $tomcat::params::catalina_properties_path,
    content => $catalina_properties,
    source  => $custom_catalina_properties,
  }

  if $custom_logging {
    $log_template = undef
  } else {
    $log_template = "template('tomcat/logging.properties.erb')"
  }

  file {'logging.properties':
    ensure  => file,
    path    => $tomcat::params::logging_properties_path,
    content => $log_template,
    source  => $custom_logging,
  }

}
