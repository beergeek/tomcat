class tomcat::params {

  $tomcat_version = hiera('tomcat::tomcat_version',7)
  if ! is_integer($tomcat_version) {
    fail("Tomcat version must be an integer, not \"${tomcat_version}\"")
  }
  if $tomcat_version !~ /^[67]$/ {
    fail("Tomcat version must be 6 or 7, not ${version}")
  }

  case $::osfamily {
    'redhat': {
      $tomcat_pkg               = "tomcat${tomcat_version}"
      $tomcat_dir               = hiera('tomcat::tomcat_dir',"/opt/tomcat${tomcat_version}")
      $tomcat_conf_dir          = "${tomcat_dir}/conf"
      $catalina_properties_path = "${tomcat_conf_dir}/catalina.properties"
      $catalina_policy_path     = "${tomcat_conf_dir}/catalina.policy"
      $logging_properties_path  = "${tomcat_conf_dir}/logging.properties"
      $tomcat_user              = hiera('tomcat::user','tomcat')
      $tomcat_grp               = hiera('tomcat::grp','tomcat')
      $tomcat_svc               = 'tomcat'
      $tomcat_java_pkg          = hiera('tomcat::java_pkg','java-1.7.0-openjdk')
    }
    'debian': {
    }
    default: {
      fail("This ${::operatingsystem} is not supported")
    }
  }
}
