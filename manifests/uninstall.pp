
class nova_compute::uninstall (
  $remove_reqs  =  false,
  $ensure       =  'absent',
) {

   class  { ::nova_compute::nova_uninstall: 
      ensure  => $ensure,
   }
   class  { ::nova_compute::neutron_uninstall: 
      ensure  => $ensure,
   }

   if $remove_reqs {
      exec { 'apt-get -y autoremove': 
         path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
      }
   }
}
