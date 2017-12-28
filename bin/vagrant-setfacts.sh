#!/bin/bash
facts_dir=/etc/puppetlabs/facter/facts.d
while [ $# -gt 0 ]; do
  case "$1" in
    --role)
      role=$2
      [ -z $2 ] && shift
    ;;
    --apptier)
      apptier=$2
      [ -z $2 ] && shift
    ;;
    --env)
      env=$2
      [ -z $2 ] && shift
    ;;
    --application)
      application=$2
      [ -z $2 ] && shift
    ;;
    *)
      echo "Unknown argument: ${2}"
      exit
    ;;
  esac
  shift 2
done

[ -d $facts_dir ] || mkdir -p $facts_dir
echo "### Setting external facts pp_role=${role} env=${env} apptier=${apptier} pp_application=${application}"
[ -z $role ] || echo "pp_role=${role}" > "${facts_dir}/pp_role.txt"
[ -z $apptier ] || echo "apptier=${apptier}" > "${facts_dir}/apptier.txt"
[ -z $env ]  || echo "env=${env}" > "${facts_dir}/env.txt"
[ -z $application ]  || echo "pp_application=${application}" > "${facts_dir}/pp_application.txt"
