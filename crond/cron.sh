#!/bin/bash
for file in /crond/*; do
	if [ -f "$file" ] && [ "${file##*/}" != "cron.sh" ]; then
		go-crond $file &
	fi
done
