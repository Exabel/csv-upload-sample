# Make sure we are in the correct directory (root of the project)
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
Push-Location (Join-Path $dir ".." "..")

# Set environment variables from environment file
# In a production setup this should be set ahead of running any script
Get-Content ".env" | foreach {$e='$Env:' + $_; Invoke-Expression $e}

# Delete entities, relationships, signals and time series
python -m scripts.py.delete_data `
    --api-key="$EXABEL_API_KEY" --namespace="$EXABEL_NAMESPACE"

Pop-Location
