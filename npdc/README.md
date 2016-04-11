NPDC
====

### update.py

Script used to update and build all npdc applications.
This script expects to be run from a directory containing separate npdc directories/repositories.

Usage:
```sh
$ ./update.py [option...] [repository...]
```

Option    | Description
----------|--------------------------------------
--no-git  | Do not pull latest changes from git
--no-npm  | Do not prune and update npm packages
--no-gulp | Do not rebuild application using gulp
