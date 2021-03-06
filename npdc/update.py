#!/usr/bin/env python

from __future__ import print_function
from subprocess import Popen, PIPE
import os
import string
import sys

actions = [
	{
		"command": [ "git", "pull" ],
		"message": "Retrieving latest git commits"
	},
	{
		"command": [ "npm", "prune" ],
		"message": "Removing extraneous npm packages"
	},
	{
		"command": [ "npm", "update", "--no-progress" ],
		"message": "Updating npm packages"
	},
	{
		"command": [ "gulp", "build" ],
		"message": "Building application with gulp"
	}
]

dirs     = []
repos    = []
dirWidth = 0
msgWidth = 0
ignore   = []

for arg in sys.argv[1:]:
	if arg[:5] == "--no-":
		ignore.append(arg[5:])
	else:
		dirs.append(arg)

if not len(dirs):
	for entry in os.listdir("."):
		dirs.append(entry)

for entry in dirs:
	if os.path.islink(entry):
		entry = os.readlink(entry)

	entry = os.path.abspath(entry)

	if os.path.isdir(entry):
		if entry not in repos:
			dirWidth = max(dirWidth, len(os.path.basename(entry)))
			repos.append(entry)

for action in actions:
	msgWidth = max(msgWidth, len(action["message"]))

countWidth = len(str(len(dirs)))

for index, entry in enumerate(repos):
	success = True
	header = "[{1:{0}}/{2:{0}}] {3} ".format(countWidth, index + 1, len(dirs), (os.path.basename(entry) + ":").ljust(1 + dirWidth))

	os.chdir(entry)

	for action in actions:
		if action["command"][0] in ignore:
			continue

		print("\r{0}{1}".format(header, (action["message"] + "...").ljust(3 + msgWidth)), end="")
		sys.stdout.flush()

		try:
			ps = Popen(action["command"], stdout=PIPE, stderr=PIPE)
			(out, err) = ps.communicate()
			ret = ps.wait()

			if ret:
				raise
		except (KeyboardInterrupt, SystemExit):
			sys.exit("\n")
		except Exception as err:
			# TODO: Do something with exceptions?
			# print(entry, string.join(action["command"]), err[1], end="")
			success = False
			break

	if success:
		print("\r{0}{1}".format(header, "Successfully updated!".ljust(3 + msgWidth)))
	else:
		print("FAILED!")
