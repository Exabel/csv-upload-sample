#!/usr/bin/env bash

set -euf

# Make sure we are in the correct directory (root of the project)
SCRIPTPATH="$(dirname "$0")"
cd $SCRIPTPATH/../..

# Set environment variables from environment file
# In a production setup this should be set ahead of running any script
source <(awk '{print "export " $0}' ./.env)

# Delete entities, relationships, signals and time series
python -m scripts.py.delete_data
