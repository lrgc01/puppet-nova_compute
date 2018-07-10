class nova_compute::neutron::files (
     $dbtype  = 'mysql',
     $dbname  = 'neutron',
     $dbuser  = 'neutron',
     $dbpass  = 'neatomos3',
     $dbhost  = 'ostackdb',
     $neutronuser  = $dbuser,
     $neutronpass  = $dbpass,
     $glanceuser  = $dbuser,
     $glancepass  = $dbpass,
     $admindbpass = 'keatomos3',
     $memcache_host = 'memcache',
     $controller_host = 'controller',
     $mq_proto = 'rabbit',
     $mq_user  = 'openstack',
     $mq_pass  = 'raatomos3',
     $mq_host  = 'rabbitmq',
     $ostack_region       = 'RegionOne',
     $bstp_adm_port       = '35357/v3/',
     $bstp_int_port       = '5000/v3/',
     $bstp_pub_port       = '5000/v3/',
     $nova_adm_port       = '8774/v2.1',
     $nova_int_port       = '8774/v2.1',
     $nova_pub_port       = '8774/v2.1',
     $placem_adm_port     = '8778',
     $placem_int_port     = '8778',
     $placem_pub_port     = '8778',
     $glance_adm_port     = '9292',
     $glance_int_port     = '9292',
     $glance_pub_port     = '9292',
     $neutron_adm_port       = '9696',
     $neutron_int_port       = '9696',
     $neutron_pub_port       = '9696',
     $memcache_port = '11211',
) {
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
   file { '/etc/neutron/neutron.conf':
      ensure    => present,
      group     => 'neutron',
      subscribe => File["${_neutron_config_dir}"],
      content   => template('nova_compute/neutron/neutron.conf.erb'),
      notify      => Exec['restart_neutron'],
   }
   # restart for each change in file
   exec { restart_neutron:
      path        => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
      refreshonly => true,
      command     => "systemctl restart neutron-linuxbridge-agent",
   }


} # neutron::files
