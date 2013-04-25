class apt::update {
  exec { '/usr/bin/apt-get update':
    timeout => 240,
    returns => [ 0, 100 ],
    unless  => '/bin/bash -c \'(( $(date +%s) - $(/usr/bin/stat -c %Y /var/lib/apt/periodic/update-success-stamp) < 86400 ))\'',
  }
}
