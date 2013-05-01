# == Class kraken::hadoop
#
class kraken::hadoop {
  require base::apt::cdh4
  $namenode_hostname        = 'kraken-vagrant.local'
  $hadoop_name_directory    = '/var/lib/hadoop/name'

  $hadoop_data_directory    = '/var/lib/hadoop/data'
  $datanode_mounts = [
    "${hadoop_data_directory}/a",
    "${hadoop_data_directory}/b",
  ]

  require kraken::config

  class { '::cdh4::hadoop':
    use_yarn             => true,
    namenode_hostname    => $namenode_hostname,
    datanode_mounts      => $datanode_mounts,
    dfs_name_dir         => [$hadoop_name_directory],
    # dfs_block_size       => 268435456,  # 256 MB
    map_tasks_maximum    => 2,
    reduce_tasks_maximum => 2,
    # map_memory_mb        => 1536,
    # io_file_buffer_size  => 131072,
    # reduce_parallel_copies => 10,
    # mapreduce_job_reuse_jvm_num_tasks => 1,
    # mapreduce_child_java_opts => '-Xmx1024M',
  }

  include cdh4::hadoop::master
  class { 'cdh4::hadoop::worker':
    require => Class['cdh4::hadoop::master'],
  }
}









# 
# class kraken::config {
#   $zookeeper_hosts    = ['kraken-vagrant.local']
#   $zookeeper_data_dir = '/var/lib/zookeeper'
# 
#   $kafka_data_dir     = '/var/lib/kafka/data'
# }
# 
# # == Class kraken::kafka
# #
# class kraken::kafka::server {
#   require kraken::config
# 
#   class { '::kafka': 
#     zookeeper_hosts => $kraken::config::zookeeper_hosts
#   }
#   file { '/var/lib/kafka':
#     ensure  => 'directory',
#     owner   => 'kafka',
#     group   => 'kafka',
#     require => Class['kafka'],
#   }
#   class { '::kafka::server':
#     data_dir => $kraken::config::kafka_data_dir,
#     require  => File['/var/lib/kafka'],
#   }
# }
# 
# # == Class kraken::zookeeper::server
# #
# class kraken::zookeeper {
#   class { 'cdh4::zookeeper':
#     hosts    => $kraken::config::zookeeper_hosts,
#     data_dir => $kraken::config::zookeeper_data_dir,
#   }
# }
# # == Class kraken::zookeeper
# #
# class kraken::zookeeper::server {
#   require kraken::zookeeper
# 
#   class { 'cdh4::zookeeper::server': }
# }