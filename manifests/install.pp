class tomcat::install (
  $manage_java = false,
) inherits tomcat::params {

  validate_bool($manage_java)

  if $manage_java {
    include tomcat::java

    $java_require = Class['tomcat::java']
  } else {
    $java_require = undef
  }

  package {'tomcat':
    ensure  => present,
    name    => $tomcat::params::tomcat_pkg,
    require => $java_require,
  }

}
