#!/bin/bash
set -eux

# Test for the presence of config/master.key or the SECRET_KEY_BASE
# environment variable, generate a new key if not specified
if [ ! -f config/master.key ] && [ -z "${SECRET_KEY_BASE:-}" ]; then
	export SECRET_KEY_BASE
	SECRET_KEY_BASE=$(rails secret)
	echo "Generated a new secret key, for production either provide config/master.key or SECRET_KEY_BASE"
fi

# Perform setup
rake db:create
rake db:migrate
rake db:seed

# Reindex
rake searchkick:reindex:all

# Start server
./bin/server "$@"
