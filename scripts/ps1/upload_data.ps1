# Make sure we are in the correct directory (root of the project)
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
Push-Location (Join-Path $dir ".." "..")

# Set environment variables from environment file
# In a production setup this should be set ahead of running any script
Get-Content ".env" | foreach {$e='$Env:' + $_; Invoke-Expression $e}

# Upload entities
python -m exabel_data_sdk.scripts.load_entities_from_csv  `
    --api-key="$EXABEL_API_KEY" --namespace="$EXABEL_NAMESPACE" `
    --filename="./resources/data/entities/brands.csv" --sep=";" `
    --name_column="brand" --description_column="description"

# Upload relationships
python -m exabel_data_sdk.scripts.load_relationships_from_csv  `
    --api-key="$EXABEL_API_KEY" --namespace="$EXABEL_NAMESPACE" `
    --filename="./resources/data/relationships/HAS_BRAND.csv" --sep=";" `
    --entity_from_column="factset_identifier" --entity_to_column="brand" `
    --relationship_type="HAS_BRAND" --description_column="description"

# Upload time series
python -m exabel_data_sdk.scripts.load_time_series_from_csv  `
    --api-key="$EXABEL_API_KEY" --namespace="$EXABEL_NAMESPACE" `
    --filename="./resources/data/time_series/brand_time_series.csv" --sep=";" `
    --create_missing_signals

Pop-Location
