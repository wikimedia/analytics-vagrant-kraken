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

# Set up Kraken Data Analysis Platform! Woooot!
# Currently this includes:
# - CDH4 Hadoop
#
class { 'kraken::hadoop': }
