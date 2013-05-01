class base {
  class { 'base::java':           }
  class { 'base::apt::wikimedia': }
  class { 'base::apt::cdh4':      }
}

class base::java {
  # Install Sun/Oracle Java JDK
  java { 'java-6-oracle':
    distribution => 'oracle',
    version      => 6,
  }
}

class base::apt::wikimedia {
  class { 'apt::update': }

  apt::repository { 'wikimedia':
    uri         => 'http://apt.wikimedia.org/wikimedia',
    dist        => "${::lsbdistcodename}-wikimedia",
    components  => 'main universe',
    comment_old => true,
  }

  # prefer Wikimedia APT repository packages in all cases
  apt::pin { 'wikimedia':
    package       => '*',
    pin           => 'release o=Wikimedia',
    priority      => 1001,
  }

  $keyurl = 'http://apt.wikimedia.org/autoinstall/keyring/wikimedia-archive-keyring.gpg'

  exec { 'apt-key_add_wikimedia':
    command => "/usr/bin/curl ${keyurl} | /usr/bin/gpg --import && gpg --export --armor Wikimedia | /usr/bin/apt-key add -",
    unless  => '/usr/bin/apt-key list | grep -q Wikimedia',
    require => Apt::Repository['wikimedia'],
  }
}

# TODO: make this use apt module?
class base::apt::cdh4 {
  $operatingsystem_lowercase = inline_template('<%= operatingsystem.downcase %>')
  $cdhversion = 4

  file { '/etc/apt/sources.list.d/cdh4.list':
    content => "deb [arch=${architecture}] http://archive.cloudera.com/cdh4/${operatingsystem_lowercase}/${lsbdistcodename}/${architecture}/cdh ${lsbdistcodename}-cdh${cdhversion} contrib\ndeb-src http://archive.cloudera.com/cdh4/${operatingsystem_lowercase}/${lsbdistcodename}/${architecture}/cdh ${lsbdistcodename}-cdh${cdhversion} contrib\n",
    mode    => 0444,
    ensure  => 'present',
  }

  exec { "import_cloudera_apt_key":
    command   => "/usr/bin/curl -s http://archive.cloudera.com/cdh4/${operatingsystem_lowercase}/${lsbdistcodename}/${architecture}/cdh/archive.key | /usr/bin/apt-key add -",
    subscribe => File['/etc/apt/sources.list.d/cdh4.list'],
    unless    => '/usr/bin/apt-key list | /bin/grep -q Cloudera',
  }

  exec { 'apt_get_update_for_cloudera':
    command     => '/usr/bin/apt-get update',
    timeout     => 240,
    returns     => [ 0, 100 ],
    refreshonly => true,
    subscribe   => [File['/etc/apt/sources.list.d/cdh4.list'], Exec['import_cloudera_apt_key']],
  }
}


