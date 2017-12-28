#!/bin/sh
# This stubs in a yaml file for application tracking, as is used in the `instance_num()` and `next_port_offset()` functions.
# Those functions write/source this yaml file during catalog compilation, which is stored on the master in normal operations.
# Since our Vagrant environments use puppet apply, this file needs to be present.

if [ ! -d "/etc/puppetlabs" ]; then
  echo "/etc/puppetlabs does not exist; skipping"
  exit 0
fi

if [ ! -d "/etc/puppetlabs/csas" ]; then
  mkdir /etc/puppetlabs/csas
fi

if [ ! -f "/etc/puppetlabs/csas/application_track.yaml" ]; then
  touch /etc/puppetlabs/csas/application_track.yaml
  cat > /etc/puppetlabs/csas/application_track.yaml <<EOT
---
application_instance: {}
port_offset: {}
EOT
fi
