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

  ssh_authorized_key { 'kevin-iMac4k':
    ensure => 'present',
    name   => $title,
    user   => 'kevin',
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQDlAAMXIwRLhnURnvIsjXkV5AawVgUR4yavk3Q6v008zgAiGiL7CTldpDNg9cwwaRT74kQmeEhYCfg3ZdHXcYL4RciAftvb/mS9rLXpEjCkIj//+h/J4L8kEBfrQt3cYr/fZsKUxj0taZNdWbLunnBJhDwpi707t1Fd6C5fcCA7VJvNHF8ewTQtdOYasgvNZVeA1/LWvLJKKZNbM2LA8ozq3/ZUjMmax1xCI3bpy9luybbQv7zqalWWBNue45LZXzFybm5MYik/lDAyk0zSEksKOaolYRW93I4L772WYcuFilzwvYvjLv01/L9MirLaMo5dfnDO6n99itbEEEKyL5WgCFXrzFICZzf5uy3MWBCcyR+wXboaPdzEUKtq0wyr+yhQi1gsyawSgvOdaWmDhVkAzPAFNawI+on0qTbgIKlPuCuOXwKnRXFnObjblZWDWdwGpv9SxutErrqVQtcWf+tRU3sWR9xuWFCfrCP7Mnvd3Xu48c6o3TFZIvNJWwzuJugJkZViYXFTHU9opBXmaLEGEFMFgGz7C+C1t+f6TtM/I+kGuiFWvdBqKaxHWnfUaqQLWu47WyhD0kiNlFCrt7dqVJ3QgdT4tt+LqNEzmHnWgDvE5mmshXrcokexmnlKTNlor6ABUOC4aGHtwQ0cplbMTNiWAEtUFk6Pyk+qOnGX2Q==',
  }

  ssh_authorized_key { 'kevin-iPhone-Working-Copy':
    ensure => 'present',
    name   => $title,
    user   => 'kevin',
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC909mvaFaJQMyHNPtyY61eU/1y0mTv9IKJk19gb9mgrxtMxew5wSB5D6LjadE1a5YeG7c0xqXqurUKSp1+R21PC3pbdqLR4j2L3930nAm7XVM+On8O54fv1QSZ0d/qyQz3eAIYRua8n1LILlBhwu9nzF9mp8siIOFaXT5LV6DCAVmBxRYzvS/unLVyyxCJtk6q7Tns/39LuUzMBHz/FaUsT/5TpvX7qxSwmJaIchjJEGKCiBL2EbgmRlwi8LbeoHat8htO2VtzYcLLUtS6gvWK1F7nAzSr3EQg2SipeC5NAl9tmedYIzR/9NBqzw4Lf/xnhSMSU7NiaEJ0Fn3mzwL7',
  }

  ssh_authorized_key { 'kevin-iPad-Working-Copy':
    ensure => 'present',
    name   => $title,
    user   => 'kevin',
    type   => 'ssh-rsa',
    key    => '',
  }

  ssh_authorized_key { 'kevin-iPad-GFE-Working-Copy':
    ensure => 'present',
    name   => $title,
    user   => 'kevin',
    type   => 'ssh-rsa',
    key    => '',
  }

  ssh_authorized_key { 'kevin-prompt':
    ensure => 'present',
    name   => $title,
    user   => 'kevin',
    type   => 'ssh-rsa',
    key    => 'AAAAB3NzaC1yc2EAAAABJQAAAQEAgBx+vF1PcDwRaznKZMM0+ksDXv53NMTH+fcfvOQtvbz9pxkQusi9HJcdnry8rOampsjeSu5wMKeJZyxISA+TJKOTyvwF0N7xHSsYY3GvHtSNH3c+Q3a2d2AW1rcYZleDa8sSYVynaeY2drCdxWJUsvujNDXNk4lSBJp6pTCESpd4xIu9Oji5ZhxlWOWG0lmX3ybQAuw9tjGYi/B2B648ZwUx9U1y1ePi0i7/85qHIauY//+p8Nagayy3vApY0g1FVyrkdh2y3tqta/cgBQCedrY+ilFlsC/XcGSsCxfKkcPiZDKSmg03opxoXsxLc6IJJhlItYRPHG20v41RfM8bPQ==',
  }
}
