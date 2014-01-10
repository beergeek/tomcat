class tomcat::service (
  $ensure = 'stopped',
  $enable = false,
) inherits tomcat::params {

  validate_bool($enable)
  if ! member(['running','stopped'],$ensure) {
    fail("Ensure must be either 'running' or 'stopped'")
  }

  service {'tomcat':
    ensure => $ensure,
    enable => $enable,
    name   => $tomcat::params::tomcat_svc,
  }
}
