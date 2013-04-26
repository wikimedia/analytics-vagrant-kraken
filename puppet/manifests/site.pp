Exec {
  logoutput => on_failure,
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

class { 'kraken': }
