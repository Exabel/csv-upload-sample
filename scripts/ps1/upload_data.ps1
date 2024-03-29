# Make sure we are in the correct directory (root of the project)
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
Push-Location (Join-Path $dir ".." "..")

# Set environment variables to be used by the scripts
# In a production setup the API key should be read from a secure location set ahead of running any script
$Env:EXABEL_API_KEY="my_api_key"
$Env:EXABEL_NAMESPACE="my_namespace"

# API key and namespace can be given explicitly through --api-key and --namespace parameters
# They can also be given implicitly using the environment variables EXABEL_API_KEY and EXABEL_NAMESPACE

# Create entity type
python -m exabel_data_sdk.scripts.create_entity_type `
    --api-key="$EXABEL_API_KEY" `
    --name="entityTypes/$EXABEL_NAMESPACE.brand" --display-name="brand" `
    --no-is-associative

# Upload entities
python -m exabel_data_sdk.scripts.load_entities_from_csv  `
    --api-key="$EXABEL_API_KEY" --namespace="$EXABEL_NAMESPACE" `
    --filename="./resources/data/entities/brands.csv" `
    --name-column="brand" --display-name-column="display_name" `
    --description-column="description"

# Create relationship type, API key is given implicitly
python -m exabel_data_sdk.scripts.create_relationship_type `
    --name="relationshipTypes/$EXABEL_NAMESPACE.HAS_BRAND" `
    --is-ownership

# Upload relationships, API key is given implicitly
python -m exabel_data_sdk.scripts.load_relationships_from_csv  `
    --filename="./resources/data/relationships/HAS_BRAND.csv" `
    --entity-from-column="factset_identifier" --entity-to-column="brand" `
    --relationship-type="HAS_BRAND" --description-column="description"

# Upload time series with known time
python -m exabel_data_sdk.scripts.load_time_series_from_csv  `
    --filename="./resources/data/time_series/brand_time_series.csv" `
    --create-missing-signals

# Or upload using PiT offset, comment in the following lines
# and comment out the previous lines
#python -m exabel_data_sdk.scripts.load_time_series_from_csv  `
#    --filename="./resources/data/time_series/brand_time_series_without_known_time.csv" `
#    --pit-offset=1 --create-missing-signals

# Upload time series on a daily/weekly/monthly schedule, setting known time to the current time (upload time)
python -m exabel_data_sdk.scripts.load_time_series_from_csv  `
    --filename="./resources/data/time_series/brand_time_series_one_day.csv" `
    --pit-current-time

# The above time series uploading work can be done by module
# exabel_data_sdk.scripts.load_time_series_from_file with the same parameters
#
# Upload time series with known time
#python -m exabel_data_sdk.scripts.load_time_series_from_file  `
#    --filename="./resources/data/time_series/brand_time_series.csv" `
#    --create-missing-signals
#
# Or upload using PiT offset
#python -m exabel_data_sdk.scripts.load_time_series_from_file `
#    --filename="./resources/data/time_series/brand_time_series_without_known_time.csv" `
#    --pit-offset=1 --create-missing-signals
#
# Upload time series on a daily/weekly/monthly schedule, setting known time to the current time (upload time)
#python -m exabel_data_sdk.scripts.load_time_series_from_file `
#    --filename="./resources/data/time_series/brand_time_series_one_day.csv" `
#    --pit-current-time

Pop-Location
