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

include base

# Hadoop
class { 'role::analytics::hadoop::master': }
class { 'role::analytics::hadoop::worker':
    require => Class['role::analytics::hadoop::master']
}

# Zookeeper
# Sigh, we can't puppetize zookeeper and hadoop at the same time on the same node :(
# class { 'role::analytics::zookeeper::server': }

