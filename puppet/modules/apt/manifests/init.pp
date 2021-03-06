class apt {
	# Directory to hold the repository signing keys
	file { '/var/lib/apt/keys':
		ensure  => directory,
		owner   => root,
		group   => root,
		mode    => '0700',
		recurse => true,
		purge   => true,
	}

	package { 'apt-show-versions':
		ensure => installed,
	}

	package { 'python-apt':
		ensure => installed,
	}

	file { '/usr/local/bin/apt2xml':
		ensure  => present,
		owner   => root,
		group   => root,
		mode    => '0755',
		source  => 'puppet:///modules/apt/apt2xml.py',
		require => Package['python-apt'],
	}
}
