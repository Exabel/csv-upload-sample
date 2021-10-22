#!/usr/bin/env bash

set -euf

# Make sure we are in the correct directory (root of the project)
SCRIPTPATH="$(dirname "$0")"
cd $SCRIPTPATH/../..

# Set environment variables to be used by the scripts
# In a production setup the API key should be read from a secure location set ahead of running any script
export EXABEL_API_KEY="my_api_key"
export EXABEL_NAMESPACE="my_namespace"

# Delete entities, relationships, signals and time series
python -m scripts.py.delete_data
