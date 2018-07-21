
class nova_compute::uninstall (
  $autoremove   =  false,
  $ensure       =  'absent',
) {

   class  { ::nova_compute::nova_uninstall: 
      ensure  => $ensure,
   }
   class  { ::nova_compute::neutron_uninstall: 
      ensure  => $ensure,
   }

   if $autoremove {
      exec { 'apt-get -y autoremove': 
         path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
      }
   }
}
