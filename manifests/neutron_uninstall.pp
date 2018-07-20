class nova_compute::neutron_uninstall (
    $ensure   = 'absent',
) {

  package { 'neutron-linuxbridge-agent':
     ensure => $ensure,
     require => Service['neutron-linuxbridge-agent'],
  }

  service { 'neutron-linuxbridge-agent':
     enable => false,
     ensure => stopped,
  }

  class { '::nova_compute::neutron::rmfiles': }

}

