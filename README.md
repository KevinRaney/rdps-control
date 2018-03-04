# RDPS Puppet Control Repository

## Overview

This is the "control repository" for RaneyDomain Professional Services (RDPS).

I use Puppet Open Source to manage multiple instances.  This should stand up
each system almost completely - minus the variable data that's backed up via
other means.

## Origin

This code base was forked from [joshbeard/vps-control](https://www.github.com/joshbeard/vps-control) and modified for use in the RDPS environment.

## Usage

This isn't usable by other people without some modification, obviously.

Clone the repo and run the bootstrap script to install puppet & r10k.

Production example:

```shell
cd
git clone https://github.com/kevinraney/rdps-control.git control
cd control
bash bootstrap.sh
```

Development example:

```shell
cd
git clone https://github.com/kevinraney/rdps-control.git control
cd control
git checkout -b develop origin/develop
bash bootstrap.sh
```

After the server is bootstraped, it will run a `puppet apply` to apple the base profile or a host specific role if it matches the hostname.

## Disclaimer

This isn't the best example of what code should look like or how to architect
your Puppet modules and environments.
