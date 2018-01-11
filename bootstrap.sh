#!/bin/bash

os=$(uname -s)

if [ $os == 'FreeBSD' ]; then
  /usr/sbin/pkg update
  /usr/sbin/pkg install -y puppet
else
  rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-6.noarch.rpm
  yum install -y puppet-agent
  echo "Symlinking Puppet binaries to /usr/local/bin..."
  ln -s /opt/puppetlabs/bin/facter /usr/local/bin/facter
  ln -s /opt/puppetlabs/bin/puppet /usr/local/bin/puppet
  ln -s /opt/puppetlabs/bin/hiera /usr/local/bin/hiera
  ln -s /opt/puppetlabs/puppet/bin/gem /usr/local/bin/gem
  ln -s /opt/puppetlabs/puppet/bin/r10k /usr/local/bin/r10k
fi

MYSELF=$(facter ipaddress)

echo "==> Installing r10k"
gem install r10k --no-ri --no-rdoc

echo "==> Installing modules from Puppetfile with r10k"
r10k puppetfile install Puppetfile -v

echo "==> Running Puppet with profile::puppet"
puppet apply -e 'include profile::puppet' --modulepath=./modules:./site

echo "==> Running Puppet with role::vps"
puppet apply -e 'include role::vps' --modulepath=./modules:./site


echo "========================================================================"
echo "#          r10k needs to populate the Puppet environments              #"
echo "========================================================================"
echo
echo "  Do the following:"
echo "    r10k deploy environment -p -v"
echo "    puppet agent -t"
echo
echo "========================================================================"
