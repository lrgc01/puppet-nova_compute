
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

   file { "${_nova_config_dir}":     # resource type directory (and its tree) in this case
      ensure  => directory,
      group   => 'nova',
      require => Package['nova-compute'],
      recurse => remote,
      source  => 'puppet:///modules/nova_compute/nova',
   }
   # Do/Redo filters, but only when the file changes
   file { "${_nova_config_dir}/nova.conf":
      ensure    => present,
      group     => 'nova',
      subscribe => File["${_nova_config_dir}"],
      content   => template('nova_compute/nova/nova.conf.erb'),
      notify    => Exec['restart_nova'],
   }
   # restart for each change in file
   exec { restart_nova:
      path        => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
      refreshonly => true,
      command     => "systemctl restart nova-compute",
   }

} # nova::files
