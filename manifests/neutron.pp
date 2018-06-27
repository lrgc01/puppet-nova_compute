class nova_compute::neutron {

  package { 'neutron_bridge':
     ensure => present,
     name => 'neutron-linuxbridge-agent',
     notify => Service['neutron-linuxbridge-agent'],
  }

  service { 'neutron-linuxbridge-agent':
     enable => true,
     require => Package['neutron_bridge'],
  }

  class { '::nova_compute::neutron::files': }

}

