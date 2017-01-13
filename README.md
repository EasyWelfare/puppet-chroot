# puppet-chroot

## Description

This puppet module can be used to set up one or multiple chroot jails

## Setup

### Requirements

This module has the following dependencies:

- stdlib: https://forge.puppet.com/puppetlabs/stdlib

## Usage

In order to use this module just include it in your manifest, the rest of the configuration can come from hiera.


### chroot::chroot

To create a chroot, you can either define it in hiera in the `chroot::chroots` hash, or using the `chroot::chroot` resource directly in puppet.
Either way, the `chroot::chroot` resource accepts the following parameters:

- **ensure** (string): whether to create or remove the chroot. Allowed values are `present` and `absent`. Defaults to `present`
- **always_rebuild** (boolean): whether to run the chroot setup script on every puppet run or just when some of the resource parameters change. Defaults to false
- **path** (string): the path where to set up the chroot jail directory tree.
- **copy** (array): list of files and directories from the local file system to copy over to the chroot directory tree. Defaults to []
- **binaries** (array): list of binaries to copy over to the chroot directory tree. They can be specified using full path or just the binary name, but in the later case you must ensure that the binary directory it's in the puppet exec `$PATH`. It's important to specify the binaries here because the module will also copy the required shared libraries that those binaries use.

### Example

In your puppet code:

```
include chroot

# To ensure that everything is in place before setting up the chroot and copy all the requested files over, this module provides an anchor that can be used like this:
User <| |> -> Anchor['chroot::before_setup']
File <| |> -> Anchor['chroot::before_setup']
Package <| |> -> Anchor['chroot::before_setup']
```

In hiera:

```yml
---
  chroot::chroots:
    jumphostchroot:
      always_rebuild: true
      path: '/opt/jumphostchroot'
      copy:
        - '/etc/group'
        - '/etc/passwd'
        - '/etc/resolv.conf'
        - '/etc/hosts'
        - '/home'
        - '/etc/bashrc'
        - '/etc/bash.bashrc'
        - '/root/db_provision.sh'
      binaries:
        - '/usr/bin/ssh'
        - '/bin/bash'
        - '/usr/bin/sh'
        - '/usr/bin/which'
        - '/usr/bin/ls'
        - 'psql'
```
