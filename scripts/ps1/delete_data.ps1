# Make sure we are in the correct directory (root of the project)
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
Push-Location (Join-Path $dir ".." "..")

# Set environment variables to be used by the scripts
# In a production setup the API key should be read from a secure location set ahead of running any script
$Env:EXABEL_API_KEY="my_api_key"
$Env:EXABEL_NAMESPACE="my_namespace"

# Delete entities, relationships, signals and time series
python -m scripts.py.delete_data

Pop-Location
