
class nova_compute::nova::rmfiles {
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
      ensure  => absent,
      require => Package['nova-compute'],
   }

} # nova::rmfiles
