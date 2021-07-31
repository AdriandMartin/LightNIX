## Project directories' structure

The role of each directory of the repository is the following one:

- `build/` stores the scripts related to the system's build process and all that files which must be copied into the root directory (system scripts and configuration files)
- `dependencies/` contains the scripts which automatically install the packages required for the system's building and testing
- `development-testing/` stores files and directories which correspond to subprojects which are developed in order to test features which want to be included into the main project
- `docs/` is the current directory, and contains the documentation of each version of the system
- `releases/` is an empty directory dedicated to store the ISO files generated while the build process
- `test/` stores the scripts dedicated to test the distribution

______________________________________________________

## System's features

The following subsections describe the main features of the operating system

### Kernel

`Linux 5.13.5` is used as the kernel, configuring it as *i386_defconfig*

### Bootloading

`SysLinux 6.03` is used as the bootloader

### Userland

The existing userland is very simple: it only consists of `Busybox 1.33.1` commands, which are copied as symbolic links when the system boots

### Standards compliantness

There are two standards which are followed:

- *LSB* compliant (specially *FHS* compliantness)

- *POSIX* compliant as long as Linux does

### Users support

Users support is implemented partially, allowing root login without password.

Busybox's login implements the system's login management. It must be taken as a provisional login, because it does not support *shadow passwords* (the passwords' hashes are stored alongside the user's credentials in */etc/passwd*)

______________________________________________________

## Development

It exists a Makefile in the root's directory of the repository which unifies the development tasks management

### Building process

For building an ISO, run the next command

```bash
make build
```

It will fetch the necessary tarballs with the source code and uncompress them inside `build/` directory. It will create also the directories `build/_rootfs` and `build/isoimage`

For distribution rebuilding, the two created directories must be removed. In order to speed up the development process, `make build` check if it exists each tarball, its correspondig extracted directory and the resulting binaries of its compilation to avoid doing the same work everytime. To erase these directories but keep the packages' related artifacts, execute the following command:

```bash
make soft-clean
```

For a complete clean-up, including the source code related files, execute the next command:

```bash
make clean
```

### Testing

For booting the generated ISO file on a virtual machine, execute the following command:

```bash
make test
```

Note that it is the most basic test which can be done, and it must be taken as a provisional test, so more complex checkings must be done as the development advances
