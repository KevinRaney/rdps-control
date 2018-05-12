##
## Profile for configuring the Puppet agent and master on the vps
##
class profile::puppet {

  include profile::params

  ## Static entry in /etc/hosts
  host { $facts['fqdn']:
    ensure => 'present',
    ip     => $facts['ipaddress'],
  }

  ## Configure r10k
  class { 'r10k':
    version     => 'latest',
    sources     => {
      'control'   => {
        'remote'  => 'https://github.com/kevinraney/rdps-control.git',
        'basedir' => $::settings::environmentpath,
        'prefix'  => false,
      }
    },
    mcollective => false,
    configfile  => $::profile::params::r10k_config_file,
    root_group  => $::profile::params::root_group,
  }

  cron { 'puppet':
    ensure      => 'present',
    command     => "${::profile::params::r10k_path} deploy environment -pv >> /var/log/puppet/r10k.log 2>&1 ; ${::profile::params::puppet_path} apply ${::settings::environmentpath}/${::environment}/manifests/site.pp --environment ${::environment} --logdest /var/log/puppet/puppet.log",
    user        => 'root',
    minute      => fqdn_rand(60),
    environment => 'PATH=/bin:/usr/bin:/usr/sbin:/usr/local/bin',
  }

}
