param(
	[Parameter(Mandatory)]
    [string]$workspace,
	[Parameter(Mandatory)]
    [string]$environment,
	[Parameter(Mandatory)]
    [string]$analysisServicesUsername,
	[Parameter(Mandatory)]
    [string]$analysisServicesPassword,
	[string]$databaseServer = "localhost",
	[string]$analysisServicesServer = "localhost"
)

Import-Module -Name SqlServer
$ErrorActionPreference = "Stop"

# Build the model
$msbuild = 'c:\Program files (x86)\MSBuild\14.0\Bin\MSBuild.exe'
& "$msbuild" TabularExample.smproj "/p:Configuration=$environment" /t:Build /p:VisualStudioVersion=14.0

# Copy build outputs and deployment options to deployment directory
$deploymentDir = ".\deployment"
mkdir -Force $deploymentDir
cp "bin\$environment\*.*" $deploymentDir
cp .\deploymentoptions\*.* $deploymentDir

# Update deployment targets with parameters
$template = Get-Content .\deploymentoptions\Model.deploymenttargets
$expandedTemplate = $ExecutionContext.InvokeCommand.ExpandString($template)
$expandedTemplate | Set-Content "$deploymentDir\Model.deploymenttargets"

# Update data sources with parameters
$template = Get-Content .\deploymentoptions\Model.configsettings
$expandedTemplate = $ExecutionContext.InvokeCommand.ExpandString($template)
$expandedTemplate | Set-Content "$deploymentDir\Model.configsettings"

# Create the deployment script
Microsoft.AnalysisServices.Deployment.exe "$deploymentDir\Model.asdatabase" /s:"$deploymentDir\deploy.log" /o:"$deploymentDir\deploy.xmla" | Out-Default

# Deploy the model
$SECURE_PASSWORD = ConvertTo-SecureString $analysisServicesPassword -AsPlainText -Force
$CREDENTIAL = New-Object System.Management.Automation.PSCredential ($analysisServicesUsername, $SECURE_PASSWORD)
Invoke-ASCmd –InputFile "$workspace\$deploymentDir\deploy.xmla" -Server $analysisServicesServer -Credential $CREDENTIAL
