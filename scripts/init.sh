#!/bin/bash

# Enabling `crond` on `/crond`
for file in /crond/*; do
	if [ -f "$file" ]; then
		go-crond $file &
	fi
done

# Setting up the default configs
gitlab-rails runner '/assets/init.rb'