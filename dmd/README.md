dmd
====

### dmd-build.sh

Script used to automatically bulid and install the newest version of **dmd**, **druntime**, **phobos** and optionally **dub**.

The script will take you through an interactive installation process with the possibility to change installation options,
such as: target machine architecture, installation path, installation of dub, and addition of related man-pages.

* **dmd** is the reference D compiler
* **druntime** is the dynamically linked D runtime library
* **phobos** is the standard D library
* **dub** is the de-facto package manager for D packages

By default, the script will suggest installing everything globally, which requires root access.

Usage:
```sh
$ ./dmd-build.sh
```
