param(
	[Parameter(Mandatory)]
    [string]$databaseUsername,
	[Parameter(Mandatory)]
    [string]$databasePassword,
	[Parameter(Mandatory)]
    [string]$analysisServicesUsername,
	[Parameter(Mandatory)]
    [string]$analysisServicesPassword,
	[string]$analysisServicesServer = "localhost",
	[string]$databaseServer = "localhost"
)

$ErrorActionPreference = "Stop"

$nuget = "$PSScriptRoot\assets\nuget.exe"
$msbuild = 'c:\Program files (x86)\MSBuild\14.0\Bin\MSBuild.exe'
$asConnectionString = "Data Source=$analysisServicesServer;Catalog=validation;User ID=$analysisServicesUsername;Password=$analysisServicesPassword"
[Environment]::SetEnvironmentVariable("SemanticModelAcceptanceTestConnectionString", $asConnectionString)
$sqlConnectionString = "Server=$databaseServer;Database=validation;User Id=$databaseUsername; Password=$databasePassword;"
[Environment]::SetEnvironmentVariable("SemanticModelAcceptanceTestSqlConnectionString", $sqlConnectionString)

& "$nuget" restore SemanticLayer.sln

& "$msbuild" SemanticLayer.sln /p:VisualStudioVersion=14.0

packages\NUnit.ConsoleRunner.3.7.0\tools\nunit3-console.exe acceptance_tests\SemanticModelValidation\SemanticModelValidation.csproj 