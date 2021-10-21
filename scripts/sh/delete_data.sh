#!/usr/bin/env bash

set -euf

# Make sure we are in the correct directory (root of the project)
SCRIPTPATH="$(dirname "$0")"
cd $SCRIPTPATH/../..

# Set variables from environment file
source ./.env

# Delete entities, relationships, signals and time series
python -m scripts.py.delete_data \
    --api-key="$EXABEL_API_KEY" --namespace="$EXABEL_NAMESPACE"
