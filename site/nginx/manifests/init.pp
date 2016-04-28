class nginx {

  $nginx_dir = '/etc/nginx'
  $www_dir = '/var/www'

  File {
    owner => 'root',
    group => 'root',
    mode => '0644',
  }

  package { 'nginx':
    ensure => present,
    before => [ File['/etc/nginx/nginx.conf'], File['/etc/nginx/conf.d/default.conf'] ],
  }

  file { "$www_dir":
    ensure => directory,
  }

  file { "$www_dir/index.html":
    ensure => file,
  }

  file { "${nginx_dir}/nginx.conf":
    ensure => file,
    source => 'puppet:///modules/nginx/nginx.conf',
  }

  file { "${nginx_dir}/conf.d/default.conf":
    ensure => file,
    source => 'puppet:///modules/nginx/default.conf',
  }

  service { 'nginx':
    ensure => running,
    enable => true,
    subscribe => [ File["${nginx_dir}/nginx.conf"], File["${nginx_dir}/conf.d/default.conf"]],
  }

}
