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

# Upload entities
python -m exabel_data_sdk.scripts.load_entities_from_csv  `
    --api-key="$EXABEL_API_KEY" --namespace="$EXABEL_NAMESPACE" `
    --filename="./resources/data/entities/brands.csv" `
    --name_column="brand" --description_column="description"

# Upload relationships
python -m exabel_data_sdk.scripts.load_relationships_from_csv  `
    --filename="./resources/data/relationships/HAS_BRAND.csv" `
    --entity_from_column="factset_identifier" --entity_to_column="brand" `
    --relationship_type="HAS_BRAND" --description_column="description"

# Upload time series with known time
python -m exabel_data_sdk.scripts.load_time_series_from_csv  `
    --filename="./resources/data/time_series/brand_time_series.csv" `
    --create_missing_signals

# Or upload using PiT offset, comment in the following lines
# and comment out the previous lines
#python -m exabel_data_sdk.scripts.load_time_series_from_csv  `
#    --filename="./resources/data/time_series/brand_time_series_without_known_time.csv" `
#    --pit_offset=1 --create_missing_signals

# Upload time series on a daily/weekly/monthly schedule, setting known time to the current time (upload time)
python -m exabel_data_sdk.scripts.load_time_series_from_csv  `
    --filename="./resources/data/time_series/brand_time_series_one_day.csv" `
    --pit_current_time

Pop-Location
