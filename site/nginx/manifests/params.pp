class nginx::params {

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
                            'debian' => 'www-data'
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
    default : {
        fail ("OS ${OperatingSystem} not recognised.")
        }
  }
}
