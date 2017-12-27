class profile::base {
  include profile::params

  case $::osfamily {
    'FreeBSD': {
      include profile::base::freebsd
    }
    'RedHat': {
      include profile::base::linux
    }
  }

  class { 'staging':
    path => $::profile::params::staging_path,
  }

  ## Install packages that aren't installed by other modules
  $packages = [
    'irssi',
    'tmux',
    'zsh',
    'lynx',
    'rsync',
    'zip',
  ]

  file { 'issue':
    ensure  => 'file',
    path    => '/etc/issue',
    content => template('profile/issue.erb'),
    owner   => 'root',
    group   => 0,
    mode    => '0644',
    backup  => false,
  }

  package { $packages:
    ensure => 'installed',
  }

  package { $::profile::params::packages:
    ensure => 'installed',
  }

  class { 'ntp': }

  class { 'timezone':
    timezone => 'MST',
  }

  user { 'kevin':
    ensure     => 'present',
    comment    => 'Kevin Raney',
    gid        => 'kevin',
    groups     => ['wheel','web'],
    home       => '/home/kevin',
    managehome => true,
    shell      => $::profile::params::shell,
    uid        => '1000',
  }

  group { 'kevin':
    ensure => 'present',
  }

  file { '/home/kevin/.ssh':
    ensure => 'directory',
    owner  => 'kevin',
    group  => 'kevin',
    mode   => '0700',
  }

  group { 'web':
    ensure => 'present',
  }

  ssh_authorized_key { 'kevin':
    ensure => 'present',
    name   => 'kevin',
    user   => 'kevin',
    type   => 'ssh-rsa',
    key    => '',
  }
}
