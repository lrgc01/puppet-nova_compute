class nova_compute::nova::files (
     $dbtype           = 'mysql',
     $dbhost           = 'ostackdb',
     $novadbname       = 'nova',
     $apidbname        = 'nova_api',
     $novadbuser       = 'nova',
     $novadbpass       = 'noatomos3',
     $novauser         = $novadbuser,
     $novapass         = $novadbpass,
     $neutrondbname    = 'neutron',
     $neutrondbuser    = 'neutron',
     $neutrondbpass    = 'neatomos3',
     $neutronuser      = $neutrondbuser,
     $neutronpass      = $neutrondbpass,
     $placemuser       = 'placement',
     $placempass       = 'platomos3',
     $glanceuser       = 'glance',
     $glancepass       = 'glatomos3',
     $admindbpass      = 'keatomos3',
     $memcache_host    = 'memcache',
     $controller_host  = 'controller2',
     $mq_proto         = 'rabbit',
     $mq_user          = 'openstack',
     $mq_pass          = 'raatomos3',
     $mq_host          = 'rabbitmq',
     $ostack_region    = 'RegionOne',
     $bstp_adm_port    = '35357/v3/',
     $bstp_int_port    = '5000/v3/',
     $bstp_pub_port    = '5000/v3/',
     $nova_adm_port    = '8774/v2.1',
     $nova_int_port    = '8774/v2.1',
     $nova_pub_port    = '8774/v2.1',
     $placem_adm_port  = '8778',
     $placem_int_port  = '8778',
     $placem_pub_port  = '8778',
     $glance_adm_port  = '9292',
     $glance_int_port  = '9292',
     $glance_pub_port  = '9292',
     $neutron_adm_port = '9696',
     $neutron_int_port = '9696',
     $neutron_pub_port = '9696',
     $memcache_port    = '11211',
) {
   case $::operatingsystem {
      'Ubuntu': {
         if $::lsbdistcodename == 'xenial' {
            $_nova_config_dir = '/etc/nova'
         } elsif $::lsbdistid == 'Ubuntu' {
            $_nova_config_dir = '/etc/nova'
         }
      }
      'Debian': {
         if $::lsbdistcodename == 'stretch' {
            $_nova_config_dir = '/etc/nova'
         } elsif $::lsbdistid == 'Debian' {
            $_nova_config_dir = '/etc/nova'
         }
      }
      /^(RedHat|CentOS|Scientific|OracleLinux|Fedora)$/: {
            $_nova_config_dir = '/etc/nova'
      }
      default: {
         $_nova_config_dir = '/etc/nova'
      }
   }

   file { "${_nova_config_dir}":     # resource type directory (and its tree) in this case
      ensure  => directory,
      group   => $novauser,
      require => Package['nova-compute'],
      recurse => remote,
      source  => 'puppet:///modules/nova_compute/nova',
   }
   # Do/Redo filters, but only when the file changes
   file { "${_nova_config_dir}/nova.conf":
      ensure    => present,
      group     => $novauser,
      subscribe => File["${_nova_config_dir}"],
      content   => template('nova_compute/nova/nova.conf.erb'),
      notify    => Exec['restart_nova'],
   }
   # restart for each change in file
   exec { restart_nova:
      path        => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
      refreshonly => true,
      command     => "systemctl restart nova-compute",
   }

} # nova::files
