class skeleton {
  file { '/etc/skel':
    endure => directory,
  }

  file { '/etc/skel/.bashrc':
    ensure => file,
    source => 'puppet:///modules/skeleton/bashrc/.bashrc',
  }
}
