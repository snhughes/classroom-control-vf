class nginx (
  $root,
  $config_dir = $nginx::params::config_dir,
  $doc_root = $nginx::params::doc_root,
  $file_owner = $nginx::params::file_owner,
  $file_group = $nginx::params::file_group,
  $package_name = $nginx::params::package_name,
  $server_block_dir = $nginx::params::server_block_dir,
  $logs_dir = $nginx::params::logs_dir,
  $service_name = $nginx::params::service_name,
  $service_user = $nginx::params::service_user,
) inherits nginx::params {

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
    content => template('nginx/nginx.conf.erb'),
  }

  file { "${server_block_dir}/default.conf":
    ensure => file,
    content => template('nginx/default.conf.erb'),
  }

  service { $service_name:
    ensure => running,
    enable => true,
    subscribe => [ File["${config_dir}/nginx.conf"], File["${server_block_dir}/default.conf"]],
  }

}
