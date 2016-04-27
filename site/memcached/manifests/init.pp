package { 'memcached':
  ensure => present,
}

file { '/etc/sysconfig/memcached':
  ensure => file,
  owner => root,
  group => root,
  more => 0644,
  source => 'puppet:///modules/memcached/memcached',
  requires => Package['memcached'],
}

service { 'memcached':
  ensure => running,
  subscribe => File['/etc/sysconfig/memcached'],
}
