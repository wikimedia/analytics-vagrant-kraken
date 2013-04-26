# == Class kraken
#
class kraken {
  require base::apt::cdh4
  require kraken::config

  class { '::kraken::zookeeper::server': }  
  class { '::kraken::kafka::server':     }
}

class kraken::config {
  $zookeeper_hosts    = ['kraken-vagrant.local']
  $zookeeper_data_dir = '/var/lib/zookeeper'

  $kafka_data_dir     = '/var/lib/kafka/data'  
}

# == Class kraken::kafka
#
class kraken::kafka::server {
  require kraken::config

  class { '::kafka': 
    zookeeper_hosts => $kraken::config::zookeeper_hosts
  }
  file { '/var/lib/kafka':
    ensure  => 'directory',
    owner   => 'kafka',
    group   => 'kafka',
    require => Class['kafka'],
  }
  class { '::kafka::server':
    data_dir => $kraken::config::kafka_data_dir,
    require  => File['/var/lib/kafka'],
  }
}

# == Class kraken::zookeeper::server
#
class kraken::zookeeper {
  class { 'cdh4::zookeeper':
    hosts    => $kraken::config::zookeeper_hosts,
    data_dir => $kraken::config::zookeeper_data_dir,
  }
}
# == Class kraken::zookeeper
#
class kraken::zookeeper::server {
  require kraken::zookeeper

  class { 'cdh4::zookeeper::server': }
}