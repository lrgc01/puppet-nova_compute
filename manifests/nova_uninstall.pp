class nova_compute::nova_uninstall (
   $ensure  = 'absent',
) {

  package { 'nova-compute':
     ensure => $ensure,
     require => Service['nova-compute'],
  }

  service { 'nova-compute':
     enable => false,
     ensure => stopped,
  }

  class { '::nova_compute::nova::rmfiles': }

}

