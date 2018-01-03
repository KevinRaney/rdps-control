# RDPS Vagrant Environments and Boxes

From [Vagrant's website](https://www.vagrantup.com/intro/index.html):

!!! quote
    Vagrant is a tool for building and managing virtual machine environments in a single workflow. With an easy-to-use workflow and focus
    on automation, Vagrant lowers development environment setup time, increases production parity, and makes the "works on my machine"
    excuse a relic of the past.

A Vagrant _box_ is basically a system image. We maintain two "flavors" of boxes - _bare_ and _base_. A _bare_ box is a minimal install of
an operating system with no provisioning done to it. A _base_ box is a minimal install that has been baseline provisioned by Puppet. The
_base_ box will likely be the most commonly used, as it will significantly decrease the time it takes to provision a Vagrant instance.

We've built our Vagrant boxes and environments to use the RDPS Puppet codebase for provisioning and managing the Vagrant instances.
These boxes and environments can be used to test new changes.

## Prerequisites

1. Download and install [VirtualBox 5.1.30](http://download.virtualbox.org/virtualbox/5.1.30/VirtualBox-5.1.30-118389-OSX.dmg)
2. Download and install [Vagrant](https://www.vagrantup.com)

## Getting Started

1. Clone the [Puppet Control repository](https://www.github.com/KevinRaney/vps-control)

        git clone git@github.com:KevinRaney/vps-control.git

2. Install dependencies

        cd control
        bundle install --path vendor/bundle

    !!! info
        You may need to do a `gem install bundler` first.

    !!! note
        By default, bundler will attempt to install Rubygems system-wide, requiring administrator access. The `--path vendor/bundle`
          argument tells Bundler to install the Rubygems listed in the Control repo's `Gemfile` into a local directory.

3. Install Puppet modules

        bundle exec r10k puppetfile install -v

4. Ready to use

    You can now use Vagrant environments in `vagrant/environments`

    For example:

        cd vagrant/environments/base_linux
        vagrant up centos6-base

### Using Vagrant

Refer to the [Vagrant Documentation](https://www.vagrantup.com/docs/index.html) at [https://www.vagrantup.com/docs/index.html](https://www.vagrantup.com/docs/index.html) for details on how to use Vagrant.

!!! info
    Execute Vagrant commands within an environment directory containing a `config.yaml` file!

Your day-to-day Vagrant commands are likely to consist mostly of:

```shell
# See the Vagrant instances in an environment and what their status is:
vagrant status

# Bring up instances in a Vagrant environment:
vagrant up

# Bring up a specific instance in a Vagrant environment:
vagrant up centos6-base

# SSH into a Vagrant instance:
vagrant ssh centos6-base

# Halt (shutdown) a Vagrant instance:
vagrant halt centos6-base

# Destroy (remove the virtual machine) a Vagrant instance:
vagrant destroy centos6-base
```

Vagrant will automatically check for updates to the _boxes_ that an environment uses whenever you bring up a Vagrant box in that
environment.

Vagrant instances are meant to be temporary - they will be used for a bit and eventually destroyed.

Instances that never get destroyed will eventually get stale. Keeping your control repository updated and running `papply` within your
instance will keep things current.

You should also periodically do housekeeping on your Vagrant boxes. You can see what boxes you have downloaded by executing:

```shell
vagrant box list
```

If you have older versions of a box, you can delete them with `vagrant box remove`.

### How Vagrant works with this repository

#### Environments

Vagrant "environments", as we're calling them, is just a specific configuration for Vagrant. For instance, there might be
an environment with systems pre-defined to bring up an application stack. The systems can have different specifications and be provisioned
by Vagrant differently, such as their puppet role.

The structure of the `vagrant` directory in the Control repository.

```
control/vagrant
├── README.md
└── environments
    ├── Vagrantfile
    ├── bare_linux
    │   ├── Vagrantfile -> ../Vagrantfile
    │   └── config.yaml
    └── base_linux
        ├── Vagrantfile -> ../Vagrantfile
        └── config.yaml
```

The `vagrant/environments` directory will contain subdirectories that make up the available Vagrant environments that we have defined.
Also here is a `Vagrantfile`, which is what Vagrant uses to determine what instances it should manage and how to manage them. Our
`Vagrantfile` is made to be reused by environments and does not require modification to add a new environment or for basic configuration
changes of the environment.

To copy an exisitng environment and maintain the `VagrantFile` symlink, use the following command:

```
cd vagrant/environments
cp -a base_linux new_env
```

The shared `Vagrantfile` is symlinked into each environment directory and a `config.yaml` file will exist alongside it. This `config.yaml`
file is what defines a Vagrant environment - what systems to provide and other tunables, such as how Puppet should be used.

To understand what settings are available for an environment, refer to the _bare_linux_ environment's `config.yaml`

#### Using Puppet

!!! note
    Puppet is not installed automatically in the _bare_linux_ environment. This is a customizable setting per-environment.

Within a Vagrant instance, the control repository directory you're working out of will be mounted on the Vagrant host to `/control/`.

Our Vagrant boxes are intended to use `puppet apply`, which does everything locally and does not communicate with the Puppet master.
However, this is also tunable. In most cases, Vagrant instances will not run Puppet with a master server.

Use the `papply` script to run Puppet. It sets arguments to point everything to the right place. This is in the system's `PATH` on the
Vagrant instance.

Vagrant boxes will typically apply a role or a specific profile.

For example:

```
papply --role tomcat::group1
```

Or

```
papply --include profile::app::doi
```

You can also apply a certain manifest file using the `--manifest` option with the path to the manifest file to apply.

_Roles_ can be found in `control/data/role/` and application _profiles_ can be found in `control/site/profile/manifests/app`.

## Staying Current

Ensure you stay current by reguarily pulling the _staging_ branch.

This repository has two permanent branches: _staging_ and _production_

To ensure your local copy of the Puppet modules are up to date with the branch, you should also run:

```
bundle exec r10k puppetfile install -v
```

The Puppet modules installed by `r10k` are used within the Vagrant environments when running Puppet.

Occasionally, you may also want to run `bundle update` to ensure the Rubygems listed in the `Gemfile` are current.

## Support

Support may be limited and delayed. Realize that some things (apps) don't yet function within a local Vagrant environment. We'll work to
improve upon that as it's needed.
