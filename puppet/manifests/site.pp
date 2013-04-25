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

class { '::kafka': }
file { '/var/lib/kafka':
  ensure  => 'directory',
  owner   => 'kafka',
  group   => 'kafka',
  require => Class['kafka'],
}
class { '::kafka::server':
  data_dir => '/var/lib/kafka/data',
  require  => File['/var/lib/kafka'],
}