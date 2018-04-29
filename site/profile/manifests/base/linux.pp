class profile::base::linux {
  include ::epel
  include ::packagecloud

  Package <<| provider == 'yum' |>>{
    require => Class['::epel'],
  }

  packagecloud::repo { 'github/git-lfs':
   type => 'rpm',
  }

  package { 'git-lfs':
    ensure  => 'latest',
    require => Packagecloud::Repo['github/git-lfs'],
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

  file_line { 'crontab_path':
    ensure => 'present',
    path   => '/etc/crontab',
    line   => 'PATH=/etc:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin',
    match  => '^PATH=',
  }
}
