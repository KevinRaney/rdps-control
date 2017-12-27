# RDPS Puppet Control Repository

## Overview

This is the "control repository" for RaneyDomain Professional Services (RDPS).

I use Puppet Open Source to manage multiple instances.  This should stand up
each system almost completely - minus the variable data that's backed up via
other means.

## Origin

This code base was forked from joshbeard/vps-control and modified for use in the RDPS environment.

## Usage

This isn't usable by other people without some modification, obviously.

Once the new server is created (see [https://github.com/joshbeard/vps-packer](Packer template)), clone this repository to the server somewhere and run the `bootstrap` script.

For example:

```shell
cd
git clone https://github.com/kevinraney/vps-control.git control
cd control
bash bootstrap.sh
```

This will install r10k, populate a temporary modules directory, and run a
`puppet apply` with the `role::vps` class.

Once that's ran, r10k will need to be ran to populate the Puppet environments:
`r10k deploy environment -pv`

## Disclaimer

This isn't the best example of what code should look like or how to architect
your Puppet modules and environments.
