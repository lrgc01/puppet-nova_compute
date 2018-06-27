
class nova_compute::nova::files {
   case $::operatingsystem {
      'Ubuntu': {
         if $::lsbdistcodename == 'xenial' {
            $_nova_config_dir = '/etc/nova'
         } elsif $::lsbdistid == 'Ubuntu' {
            $_nova_config_dir = '/etc/nova'
         }
      }
      'Debian': {
         if $::lsbdistcodename == 'stretch' {
            $_nova_config_dir = '/etc/nova'
         } elsif $::lsbdistid == 'Debian' {
            $_nova_config_dir = '/etc/nova'
         }
      }
      /^(RedHat|CentOS|Scientific|OracleLinux|Fedora)$/: {
            $_nova_config_dir = '/etc/nova'
      }
      default: {
         $_nova_config_dir = '/etc/nova'
      }
   }

   file { "${_nova_config_dir}":     # resource type file and filename
      ensure  => directory,
      mode    => '0755',
      recurse => remote,
      source  => 'puppet:///modules/nova_compute/nova',
   }
   # Rebuild the database, but only when the file changes
   exec { update_nova_files:
      path        => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
      subscribe   => File["${_nova_config_dir}"],
      refreshonly => true,
      command	  => "sed -e 's/__2ND_IP__/'$::ipaddress_enp0s5f1'/' < ${_nova_config_dir}/nova.conf.tmpl > ${_nova_config_dir}/nova.conf",
   }

#   file { "${_nova_config_dir}/nova-compute.conf":     # resource type file and filename
#      ensure  => present,    	# make sure it exists
#      mode    => '0644',     	# file permissions
#      content => "
#[DEFAULT]
#compute_driver=libvirt.LibvirtDriver
#[libvirt]
#virt_type=qemu
#
#",  
#   }

} # nova::files
