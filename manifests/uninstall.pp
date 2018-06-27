
class nova_compute::uninstall {
   class  { ::nova_compute::nova_uninstall: }
   class  { ::nova_compute::neutron_uninstall: }
   exec { 'apt -y autoremove': 
      path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
   }
}
