#!/bin/bash

# initial steps
apt-get update
apt-get install -y lsof 

# Enabling `crond` on `/crond`
for file in /crond/*; do
	if [ -f "$file" ]; then
		# `go-crond` don't take into account files
		# that allow non-owner users to edit it
		chmod go-w "$file"
		go-crond "$file" &
	fi
done

# Setting up the default configs
gitlab-rails runner '/assets/init.rb'

# Change the owner of `/backups`
# As Gitlab automatically change it to `git:git`
# (because else, as the host, we can't read the backups)
# And also because Gitlab re-change the owner when it use the directory
# (do it does not have any consequence)
chown -R "$DEFAULT_FILE_UID":"$DEFAULT_FILE_GID" /backups
chmod -R "$DEFAULT_FILE_RIGHT" /backups