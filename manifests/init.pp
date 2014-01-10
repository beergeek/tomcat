# == Class: tomcat
#
# Full description of class tomcat here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { tomcat:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2014 Your name here, unless otherwise noted.
#
class tomcat (
  $manage_java                = false,
  $ensure                     = 'stopped',
  $enable                     = false,
  $shared_loader              = undef,
  $server_loader              = undef,
  $handler_level              = 'FINE',
  $logger_level               = 'INFO',
  $custom_logging             = undef,
  $custom_catalina_policy     = undef,
  $custom_catalina_properties = undef,
) {

  class {'tomcat::install':
    manage_java => $manage_java,
  }
  class {'tomcat::config':
    server_loader              => $server_loader,
    shared_loader              => $shared_loader,
    handler_level              => $handler_level,
    logger_level               => $logger_level,
    custom_logging             => $custom_logging,
    custom_catalina_policy     => $custom_catalina_policy,
    custom_catalina_properties => $custom_catalina_properties,
  }
  class {'tomcat::service':
    ensure => $ensure,
    enable => $enable,
  }
}
