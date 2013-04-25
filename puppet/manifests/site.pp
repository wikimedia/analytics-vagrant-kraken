Exec {
  logoutput => on_failure,
}

Package {
  require => Exec['update-package-index'],
}


if ( $::virtualbox_version ) {
  notice("Detected VirtualBox version ${::virtualbox_version}")
} else {
  warning('Could not determine VirtualBox version.')
}

group { 'puppet':
  ensure => present,
}

class { 'base': }