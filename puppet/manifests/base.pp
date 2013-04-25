class base {
  class { 'base::apt::wikimedia': }
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
    command => "/usr/bin/curl $keyurl | /usr/bin/gpg --import && gpg --export --armor Wikimedia | /usr/bin/apt-key add -",
    unless  => '/usr/bin/apt-key list | grep -q Wikimedia',
    require => Apt::Repository['wikimedia'],
  }
}