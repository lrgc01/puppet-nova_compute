class nova_compute::nova_uninstall {

  package { 'nova-compute':
     ensure => absent,
     name => 'nova-compute',
     require => Service['stop-nova-compute'],
  }

  service { 'stop-nova-compute':
     name   => 'nova-compute',
     enable => false,
     ensure => stopped,
  }

  class { '::nova_compute::nova::rmfiles': }

}

