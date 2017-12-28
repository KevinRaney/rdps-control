#!/bin/bash
lock_file='/var/tmp/vagrant-setup_papply.lock'
puppet_env=${1:-production}

echo "### Installing dependencies needed for puppet apply mode"

if [ $(facter osfamily) == 'Debian' ]; then
  puppet resource package ruby ensure=present
else
  puppet resource package rubygems ensure=present
fi

echo "### Installing gems with provider gem"
puppet resource package hiera-eyaml provider=gem ensure=present
puppet resource package deep_merge provider=gem ensure=present
echo "### Installing gems with provider puppet_gem"
puppet resource package hiera-eyaml provider=puppet_gem ensure=present
puppet resource package deep_merge provider=puppet_gem ensure=present
puppet resource package r10k provider=puppet_gem ensure=present
echo "### Installing git"
puppet resource package git ensure=present
which puppetserver 2>/dev/null
if [ "x$?" == "x0" ]; then
  echo "### Installing gems for puppetserver"
  puppetserver gem install hiera-eyaml
  puppetserver gem install deep_merge
  service pe-puppetserver restart
fi

if [ ! -f "/etc/puppetlabs/puppet/keys/private_key.pkcs7.pem" ]; then
  echo "### Creating eyaml keys"
  /opt/puppetlabs/puppet/bin/eyaml createkeys \
    --pkcs7-private-key=/etc/puppetlabs/puppet/keys/private_key.pkcs7.pem \
    --pkcs7-public-key=/etc/puppetlabs/puppet/keys/public_key.pkcs7.pem
fi

if [ ! -e "/usr/local/bin/papply" ]; then
  echo "Linking /control/bin/papply.sh to /usr/local/bin/papply"
  ln -s /control/bin/papply.sh /usr/local/bin/papply
fi
