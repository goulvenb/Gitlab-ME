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