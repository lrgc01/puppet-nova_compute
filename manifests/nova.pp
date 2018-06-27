class nova_compute::nova {

  package { 'nova-compute':
     ensure => present,
     name => 'nova-compute',
     notify => Service['nova-compute'],
  }

  service { 'nova-compute':
     enable => true,
     require => Package['nova-compute'],
  }

  class { '::nova_compute::nova::files': }

}

