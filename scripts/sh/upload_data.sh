#!/usr/bin/env bash

set -euf

# Make sure we are in the correct directory (root of the project)
SCRIPTPATH="$(dirname "$0")"
cd $SCRIPTPATH/../..

# Set environment variables from environment file
# In a production setup the API key should be read from a secure location set ahead of running any script
source <(awk '{print "export " $0}' ./.env)

# API key and namespace can be given explicitly through --api-key and --namespace parameters
# They can also be given implicitly using the environment variables EXABEL_API_KEY and EXABEL_NAMESPACE

# Upload entities
python -m exabel_data_sdk.scripts.load_entities_from_csv  \
    --api-key="$EXABEL_API_KEY" --namespace="$EXABEL_NAMESPACE" \
    --filename="./resources/data/entities/brands.csv" \
    --name_column="brand" --description_column="description"

# Upload relationships, or implicitly
python -m exabel_data_sdk.scripts.load_relationships_from_csv  \
    --filename="./resources/data/relationships/HAS_BRAND.csv" \
    --entity_from_column="factset_identifier" --entity_to_column="brand" \
    --relationship_type="HAS_BRAND" --description_column="description"

# Upload time series
python -m exabel_data_sdk.scripts.load_time_series_from_csv  \
    --filename="./resources/data/time_series/brand_time_series.csv" \
    --create_missing_signals
