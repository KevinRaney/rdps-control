#!/bin/bash
#
# Wrapper script for running `puppet apply`
#
# This just sets up the paths for sourcing Puppet code
#
# Example usage:
#
#   papply.sh --role tomcat::group1
#   papply.sh --manifest /control/manifests/site.pp
#   papply.sh --include profile::app::doi
#
env="production"
base_dir="/etc/puppetlabs/code/environments/${env}"
manifest="${base_dir}/manifests/site.pp"
include=""
role=""
role_data="${base_dir}/data/role"

if [ "$EUID" -ne 0 ] && [ -z "$PAPPLY_NO_ROOT" ]; then
  echo "Please run $0 as root or set PAPPLY_NO_ROOT=true to run as a non-root user"
  echo "> Hint: sudo su -"
  exit 1
fi

while [ $# -gt 0 ]; do
  case "$1" in
    --role)
      role=$2
      shift 2
    ;;
    --include)
      include=$2
      shift 2
    ;;
    --env)
      env=$2
      shift 2
    ;;
    --manifest)
      manifest=$2
      shift 2
    ;;
    *)
      exit
    ;;
  esac
done

PATH=$PATH:/opt/puppetlabs/bin

echo "## Running Puppet apply on ${manifest}, environment ${env}. Puppet version $(puppet --version)"
echo

if [ "x${role}" != "x" ] ; then
  # Check if the role exists
  if [ ! -f "${role_data}/${role}.yaml" ]; then
    echo "Error: The specified role ${role} was not found at ${role_data}/${role}.yaml"
    exit 1
  fi

  echo "======= Applying role: ${role}"
  export FACTER_pp_role=$role
fi

if [ "x${include}" != "x" ] ; then
  echo "======= Including class: ${include}"
  export FACTER_include=$include
fi

echo "======= Applying manifest: ${manifest}"

puppet --version | grep -q -e "^[4,5]"
if [ "x$?" == "x0" ] ; then
  manifest_option=''
else
  manifest_option="--manifestdir ${base_dir}/manifests"
fi

puppet apply --test --report --summarize \
	--modulepath "${base_dir}/site:${base_dir}/modules:/etc/puppet/modules" \
	--environmentpath "${base_dir}/.." \
	--environment $env \
	--hiera_config "${base_dir}/hiera.yaml" \
	$manifest_option $manifest

result=$?
if [ "x$result" == "x0" ] || [ "x$result" == "x2" ]; then
  exit 0
else
  exit 1
fi

