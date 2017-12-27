class role::web-aachurch {
  include profile::base
  include profile::base::linux
  include profile::firewall
  include profile::ssh
  include profile::sudoers
  include profile::puppet
  include profile::letsencrypt
}