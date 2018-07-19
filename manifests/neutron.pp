class nova_compute::neutron (
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

  package { 'neutron_bridge':
     ensure => present,
     name => 'neutron-linuxbridge-agent',
     notify => Service['neutron-linuxbridge-agent'],
  }

  service { 'neutron-linuxbridge-agent':
     enable => true,
     require => Package['neutron_bridge'],
  }

  class { '::nova_compute::neutron::files': 
     dbtype           => $dbtype,
     dbhost           => $dbhost,
     novadbname       => $novadbname,
     novadbuser       => $novadbuser,
     novadbpass       => $novadbpass,
     novauser         => $novadbuser,
     novapass         => $dnovabpass,
     apidbname        => $apidbname,
     neutrondbname    => $neutrondbname,
     neutrondbuser    => $neutrondbuser,
     neutrondbpass    => $neutrondbpass,
     neutronuser      => $neutrondbuser,
     neutronpass      => $neutrondbpass,
     placemuser       => $placemuser,
     placempass       => $placempass,
     glanceuser       => $dbuser,
     glancepass       => $dbpass,
     admindbpass      => $admindbpass,
     memcache_host    => $memcache_host,
     controller_host  => $controller_host,
     mq_proto         => $mq_proto,
     mq_user          => $mq_user,
     mq_pass          => $mq_pass,
     mq_host          => $mq_host,
     ostack_region    => $ostack_region,
     bstp_adm_port    => $bstp_adm_port,
     bstp_int_port    => $bstp_int_port,
     bstp_pub_port    => $bstp_pub_port,
     nova_adm_port    => $nova_adm_port,
     nova_int_port    => $nova_int_port,
     nova_pub_port    => $nova_pub_port,
     placem_adm_port  => $placem_adm_port,
     placem_int_port  => $placem_int_port,
     placem_pub_port  => $placem_pub_port,
     glance_adm_port  => $glance_adm_port,
     glance_int_port  => $glance_int_port,
     glance_pub_port  => $glance_pub_port,
     neutron_adm_port => $neutron_adm_port,
     neutron_int_port => $neutron_int_port,
     neutron_pub_port => $neutron_pub_port,
     memcache_port    => $memcache_port,
  }

}

