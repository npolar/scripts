#!/usr/bin/env python

from __future__ import print_function
from subprocess import call, PIPE
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

dirs = []
dirWidth = 0
msgWidth = 0
ignore = []

for arg in sys.argv:
	if arg[:5] == "--no-":
		ignore.append(arg[5:])

for entry in os.listdir("."):
	if os.path.islink(entry):
		entry = os.readlink(entry)

	entry = os.path.abspath(entry)

	if os.path.isdir(entry):
		if entry not in dirs:
			dirWidth = max(dirWidth, len(os.path.basename(entry)))
			dirs.append(entry)

for action in actions:
	msgWidth = max(msgWidth, len(action["message"]))

countWidth = len(str(len(dirs)))

for index, entry in enumerate(dirs):
	success = True
	header = "[{1:{0}}/{2:{0}}] {3} ".format(countWidth, index + 1, len(dirs), (os.path.basename(entry) + ":").ljust(1 + dirWidth))

	for action in actions:
		if action["command"][0] in ignore:
			continue

		print("\r{0}{1}".format(header, (action["message"] + "...").ljust(3 + msgWidth)), end="")
		sys.stdout.flush()
		os.chdir(entry)

		try:
			if call(action["command"], stdout=PIPE, stderr=PIPE) != 0:
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
