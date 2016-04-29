class nginx {

  case $::osfamily {
    'redhat' : {
        $config_dir = '/etc/nginx'
        $doc_root = '/var/www'
        $file_owner = 'root'
        $file_group = 'root' 
        $package_name = 'nginx'
        $server_block_dir = "${config_dir}/conf.d"
        $logs_dir = '/var/log/nginx'
        $service_name = 'nginx'
        $service_user = $::osfamily ? {
                            'redhat' => 'nginx',
                            'debian' => 'www-data',
                            }
        }
    'windows' : {
        $config_dir = 'C:/ProgramData/nginx'
        $doc_root = 'C:/ProgramData/nginx/html'
        $file_owner = 'Administrator'
        $file_group = 'Administrator'
        $package_name = 'nginx-service'
        $server_block_dir = "${config_dir}/conf.d"
        $logs_dir = '${config_dir}/logs'
        $service_name = 'nginx'
        $service_user = 'nobody'
        }
  }
    

  File {
    owner => $file_owner,
    group => $file_group,
    mode => '0644',
  }

  package { $package_name :
    ensure => present,
    before => [ File["${config_dir}/nginx.conf"], File["${server_block_dir}/default.conf"] ],
  }

  file { "${doc_root}":
    ensure => directory,
  }

  file { "${doc_root}/index.html":
    ensure => file,
  }

  file { "${config_dir}/nginx.conf":
    ensure => file,
    source => 'puppet:///modules/nginx/nginx.conf',
  }

  file { "${server_block_dir}/conf.d/default.conf":
    ensure => file,
    source => 'puppet:///modules/nginx/default.conf',
  }

  service { $service_name:
    ensure => running,
    enable => true,
    subscribe => [ File["${config_dir}/nginx.conf"], File["${config_dir}/conf.d/default.conf"]],
  }

}
