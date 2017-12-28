#!/bin/bash
#
# This sets up the Puppet environments directory to link to the Vagrant-mounted control repo
#
arg=$1
env=${1:-production}
mount_dir=${2:-'/control'}

link_controlrepo() {
  echo "### Linking Puppet ${env} environment to local development directory."
  [ -d /etc/puppetlabs/code/environments/$env ] && mv /etc/puppetlabs/code/environments/$env /etc/puppetlabs/code/environments/$env_$(date +%Y%m%d_%H%M%S)
  ln -sf $mount_dir /etc/puppetlabs/code/environments/$env
}

link_target=$(readlink /etc/puppetlabs/code/environments/$env)
if [ "$link_target" != "$mount_dir" ]; then
  link_controlrepo $env
  cat << EOT > /etc/motd.local

You'll find a copy of the Puppet control repository in /control/

Use 'papply' to execute Puppet (puppet apply).

A list of Puppet roles can be found in '/control/data/roles/' and
application profiles can be viewed in '/control/site/profile/manifests/app/'

A role can be applied like this:

    papply --role tomcat::app::ome

An individual application profile (or other Puppet class/manifest) can be
applied using the --manifest argument:

    papply --manifest profile::app::ome

EOT
cp /etc/motd.local /etc/motd
fi
