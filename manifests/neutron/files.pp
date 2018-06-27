
class nova_compute::neutron::files {
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
   $_neutron_ml2_ini_file = "${_neutron_plugin_dir}/ml2-linuxbridge_agent.ini"

   file { "${_neutron_config_dir}":     # resource type file and filename
      ensure  => directory,
      mode    => '0755',
      recurse => remote,
      source  => 'puppet:///modules/nova_compute/neutron',
   }
   # Rebuild the database, but only when the file changes
   exec { update_neutron_files:
      path        => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
      subscribe   => File["${_neutron_config_dir}"],
      refreshonly => true,
      command	  => "sed -e 's/__1ST_IFACE__/enp0s5f0/' -e 's/__2ND_IP__/'$::ipaddress_enp0s5f1'/' < ${_neutron_ml2_ini_file}.tmpl > ${_neutron_ml2_ini_file}",
   }


} # neutron::files
