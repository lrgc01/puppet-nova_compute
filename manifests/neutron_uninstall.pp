class nova_compute::neutron_uninstall {

  package { 'neutron_bridge':
     ensure => absent,
     name => 'neutron-linuxbridge-agent',
     require => Service['neutron-linuxbridge-agent'],
  }

  service { 'neutron-linuxbridge-agent':
     enable => false,
     ensure => stopped,
  }

  class { '::nova_compute::neutron::rmfiles': }

}

