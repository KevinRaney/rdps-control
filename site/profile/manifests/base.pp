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

  file_line { 'crontab_path':
    ensure => 'present',
    path   => '/etc/crontab',
    line   => 'PATH=/etc:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin',
    match  => '^PATH=',
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

  ssh_authorized_key { 'kevin@Kevins-MacBook-Pro.local':
    user => 'kevin',
    type => 'rsa',
    key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCaxMM17UVYysAee1egRrUADUsqcG3VY0iAT4r/YdVG1rlJsPc/Zl41vHIq5jYl6SrAZXaV7V8r0TFFP8iuJQYjyP5Z0MAt230OERPbxMr3rZhjm7Z0KLK+spXUvV+HZoAL17NvZ8w9KC+bae63mvaQ/T/6A7YI7U9TwRdWY6oGHzRtPruBPFBpQxsFfl2p6Xj1G52VafeZdoR9p14A39w0gyQsNm0epfkXEUwvVC5O7rqm6HWOwz06xxHbhTgD20K8mkym8KL9q+Sql3fsSdYnRSWbUFYcS5OXR4RMur2G+USwF9Old0NXOkvzGsIzWVPryB2hqeDFwHKEddm5s9nB',
  }

  ssh_authorized_key { 'root@web.rd':
    user => 'kevin',
    type => 'rsa',
    key => 'AAAAB3NzaC1yc2EAAAABIwAAAQEA1JuWKsxdoSVoTuN0182p9+Tou6rN6NzeP9TWcPOIPx3UxixHjtP/i2XBJS2bT/tUcNLy5DKVplcUNHPvdYFOTAqyQfmk//ALfoU5esDvAEFNXP5uwUJK9b6r2t7LWQACsJfO3F8R5RpyhKf/7FzxSQdYjCTarisMJnE78QCdH6jDKSgP6Ev+iYj0rhqOJOKs5CfGklsRUibuMSBGpaogmg+wp3bcP0OJQXBi87xnEfj1tLIHLh9hUAUtyWPNlX8MZr3lvzcK7b53IGfODJamMmn3aIuu9da9ts0BY1Wd+ff91o1EPWiR525FqZL/OD9TewWyU+Z+JfT3iEXmQffHlQ==',
  }

  ssh_authorized_key { 'kevin@ios.prompt':
    user => 'kevin',
    type => 'rsa',
    key => 'AAAAB3NzaC1yc2EAAAABJQAAAQEAgBx+vF1PcDwRaznKZMM0+ksDXv53NMTH+fcfvOQtvbz9pxkQusi9HJcdnry8rOampsjeSu5wMKeJZyxISA+TJKOTyvwF0N7xHSsYY3GvHtSNH3c+Q3a2d2AW1rcYZleDa8sSYVynaeY2drCdxWJUsvujNDXNk4lSBJp6pTCESpd4xIu9Oji5ZhxlWOWG0lmX3ybQAuw9tjGYi/B2B648ZwUx9U1y1ePi0i7/85qHIauY//+p8Nagayy3vApY0g1FVyrkdh2y3tqta/cgBQCedrY+ilFlsC/XcGSsCxfKkcPiZDKSmg03opxoXsxLc6IJJhlItYRPHG20v41RfM8bPQ==',
  }

  ssh_authorized_key { 'kevin@iphone.workingcopy':
    user => 'kevin',
    type => 'rsa',
    key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC909mvaFaJQMyHNPtyY61eU/1y0mTv9IKJk19gb9mgrxtMxew5wSB5D6LjadE1a5YeG7c0xqXqurUKSp1+R21PC3pbdqLR4j2L3930nAm7XVM+On8O54fv1QSZ0d/qyQz3eAIYRua8n1LILlBhwu9nzF9mp8siIOFaXT5LV6DCAVmBxRYzvS/unLVyyxCJtk6q7Tns/39LuUzMBHz/FaUsT/5TpvX7qxSwmJaIchjJEGKCiBL2EbgmRlwi8LbeoHat8htO2VtzYcLLUtS6gvWK1F7nAzSr3EQg2SipeC5NAl9tmedYIzR/9NBqzw4Lf/xnhSMSU7NiaEJ0Fn3mzwL7',
  }

  ssh_authorized_key { 'kevin@ipad.workingcopy':
    user => 'kevin',
    type => 'rsa',
    key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDDNYv0zGCB4wbl6GFHDf6ppyjpXm7LwVJyPPDLlzw7Jdyq9AuyuY2mdyZnDKsQCanEyq6dSVR2eEh1ak2gYAnciouQDnVt6nSw5ZTz2PWK8A79QAeiN/efVEeyMRnZcf56XiA7VEFxDpLaEW6QjcEGyQ0F5988BJIzVXWiFzRYvvkckxL4Wds0x82YPfRPpwuoX38jz5MYYD74QGrOnkSEeCsB9Nd09WBNe9UitA17Ocu16ypFzOXrYDVYRZ7vXRjbWEGvi8bJKSlnyo5yfGGUtCftp6Ac0qrN0pkcZ0CgnJevF9AoW4jx0Cx64guI7ku+9+gP5vrB0t9WzSaAQ/hp',
  }

  ssh_authorized_key { 'kevin@Kevins-5K-iMac.local':
    user => 'kevin',
    type => 'rsa',
    key => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQDlAAMXIwRLhnURnvIsjXkV5AawVgUR4yavk3Q6v008zgAiGiL7CTldpDNg9cwwaRT74kQmeEhYCfg3ZdHXcYL4RciAftvb/mS9rLXpEjCkIj//+h/J4L8kEBfrQt3cYr/fZsKUxj0taZNdWbLunnBJhDwpi707t1Fd6C5fcCA7VJvNHF8ewTQtdOYasgvNZVeA1/LWvLJKKZNbM2LA8ozq3/ZUjMmax1xCI3bpy9luybbQv7zqalWWBNue45LZXzFybm5MYik/lDAyk0zSEksKOaolYRW93I4L772WYcuFilzwvYvjLv01/L9MirLaMo5dfnDO6n99itbEEEKyL5WgCFXrzFICZzf5uy3MWBCcyR+wXboaPdzEUKtq0wyr+yhQi1gsyawSgvOdaWmDhVkAzPAFNawI+on0qTbgIKlPuCuOXwKnRXFnObjblZWDWdwGpv9SxutErrqVQtcWf+tRU3sWR9xuWFCfrCP7Mnvd3Xu48c6o3TFZIvNJWwzuJugJkZViYXFTHU9opBXmaLEGEFMFgGz7C+C1t+f6TtM/I+kGuiFWvdBqKaxHWnfUaqQLWu47WyhD0kiNlFCrt7dqVJ3QgdT4tt+LqNEzmHnWgDvE5mmshXrcokexmnlKTNlor6ABUOC4aGHtwQ0cplbMTNiWAEtUFk6Pyk+qOnGX2Q==',
  }

  ssh_authorized_key { 'kevin@RDPS-Server.private':
    user => 'kevin',
    type => 'rsa',
    key => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC3WLff4jgyzbSfk7GgU5RmICv73bDLus236JR45F+fHnXB4QDYwUhJNSgPgNhLufvPgcmC/P/FhiAKgmMxGETwe3wHnI/ngtODNm1ghOPfyfiqgvFFQ3/FLb3KXlFo0B7BGW9ZbtfZeNf8/VWsAXkv71twczYPyQLwjV+t6o/3QfH9W968EeNoJ2+14tAeSKcXRp2qbYttr8Er5bxhCljcmu6B72zACBshAGkPCco05fYAwxYIhGD4Unh0idcaF5ce4+5vPtWOREzmBZqGFv8LM0MsBVWSWS4aqSfrtlrHCes4hZtJ5wjir5OVn2p3mwNMZo++qPlO0xFFD3FgJvp7',
  }

  group { 'web':
    ensure => 'present',
  }
}
