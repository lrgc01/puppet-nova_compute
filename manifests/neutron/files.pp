
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

   if has_key($::networking,'primary') {
      $provider_interface = $::networking['primary']
   } else {
      $provider_interface = 'enp0s5f0'
   }
   $_neutron_plugin_dir = "${_neutron_config_dir}/plugins"
   $_neutron_ml2_ini_file = "${_neutron_plugin_dir}/ml2/linuxbridge_agent.ini"

   file { "${_neutron_config_dir}":     # resource type directory (and its tree) in this case
      ensure  => directory,
      group   => 'neutron',
      require => Package[neutron_bridge],
      recurse => remote,
      source  => 'puppet:///modules/nova_compute/neutron',
   }
   # Do/Redo filters, but only when the file changes
   file { $_neutron_ml2_ini_file:
      ensure    => present,
      group     => 'neutron',
      subscribe => File["${_neutron_config_dir}"],
      content   => template('nova_compute/neutron/plugins/ml2/linuxbridge_agent.ini.erb'),
      notify      => Exec['restart_neutron'],
   }
   # restart for each change in file
   exec { restart_neutron:
      path        => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
      refreshonly => true,
      command     => "systemctl restart neutron-linuxbridge-agent",
   }


} # neutron::files
