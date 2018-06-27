class nova_compute {
  class { '::nova_compute::nova': }
  class { '::nova_compute::neutron': }
}
