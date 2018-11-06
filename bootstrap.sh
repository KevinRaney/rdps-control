#!/bin/sh

os=`uname -s`

if [ $os == 'FreeBSD' ]; then
  /usr/sbin/pkg update
  /usr/sbin/pkg install -y puppet4
  /usr/sbin/pkg install -y rubygem-r10k
else
  rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-6.noarch.rpm
  yum-config-manager --enable rhel-server-rhscl-7-rpms
  yum install -y puppet-agent centos-release-scl rh-ruby23
  echo "Enabling Ruby 2.3"
  cp ~/control/rh-ruby23.sh /etc/profile.d/rh-ruby23.sh
  source /etc/profile.d/rh-ruby.sh
  echo "Symlinking Puppet binaries to /usr/local/bin..."
  ln -s /opt/puppetlabs/bin/facter /usr/local/bin/facter
  ln -s /opt/puppetlabs/bin/puppet /usr/local/bin/puppet
  ln -s /opt/puppetlabs/bin/hiera /usr/local/bin/hiera
  ln -s /opt/puppetlabs/puppet/bin/gem /usr/local/bin/gem
  ln -s /opt/puppetlabs/puppet/bin/r10k /usr/local/bin/r10k

  echo "==> Installing r10k"
  gem install r10k --no-ri --no-rdoc
fi

MYSELF=`facter ipaddress`

echo "==> Installing modules from Puppetfile with r10k"
r10k puppetfile install Puppetfile -v

echo "==> Running Puppet apply"
puppet apply manifests/site.pp --modulepath=./modules:./site --hiera_config=hiera.yaml

echo "================================================================================================"
echo "#          r10k needs to populate the Puppet environments                                      #"
echo "================================================================================================"
echo
echo "  Do the following:"
echo "    cd ~/control"
echo "    r10k deploy environment -p -v"
echo "    puppet apply manifests/site.pp --modulepath=./modules:./site --hiera_config=hiera.yaml"
echo
echo "================================================================================================"
