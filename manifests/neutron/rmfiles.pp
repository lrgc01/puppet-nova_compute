
class nova_compute::neutron::rmfiles {
   case $::operatingsystem {
      'Ubuntu': {
         if $::lsbdistcodename == 'xenial' {
            $_neutron_config_dir = '/etc/neutron'
         } elsif $::lsbdistid == 'Ubuntu' {
            $_neutron_config_dir = '/etc/neutron'
         }
      }
      'Debian': {
         if $::lsbdistcodename == 'stretch' {
            $_neutron_config_dir = '/etc/neutron'
         } elsif $::lsbdistid == 'Debian' {
            $_neutron_config_dir = '/etc/neutron'
         }
      }
      /^(RedHat|CentOS|Scientific|OracleLinux|Fedora)$/: {
            $_neutron_config_dir = '/etc/neutron'
      }
      default: {
         $_neutron_config_dir = '/etc/neutron'
      }
   }

   $_neutron_plugin_dir = "${_neutron_config_dir}/plugins"
   $_neutron_ml2_ini_file = "${_neutron_plugin_dir}/ml2/linuxbridge_agent.ini"

   file { "${_neutron_config_dir}":     # resource type file and filename
      ensure  => absent,
      require => Package['neutron-linuxbridge-agent'],
   }

} # neutron::files
