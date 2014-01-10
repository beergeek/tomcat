class tomcat::java {

  include $tomcat::params

  package {'java':
    ensure => present,
    name   => $tomcat::params::tomcat_java_pkg,
  }

}
