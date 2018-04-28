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

  file { 'dynmotd':
    ensure => 'file',
    path   => '/usr/local/bin/dynmotd.sh',
    mode   => '0755',
    owner  => 'root',
    group  => 0,
    source => 'puppet:///modules/profile/dynmotd.sh',
  }

  cron { 'dynmotd':
    ensure  => 'present',
    command => '/usr/local/bin/dynmotd.sh > /etc/motd',
    minute  => '*/5',
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
}
