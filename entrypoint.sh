#!/bin/bash
set -eu

# Test for the presence of config/master.key
if [ ! -f config/master.key ]; then
	echo "ERROR: required configuration \"config/master.key\" not found" > /dev/stderr
	exit
fi

# Perform setup
rake db:create
rake db:seed

# Reindex
rake searchkick:reindex:all

# Start server
./bin/server "$@"
