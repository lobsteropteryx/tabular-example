param(
	[Parameter(Mandatory)]
    [string]$environment,
	[Parameter(Mandatory)]
    [string]$analysisServicesUsername,
	[Parameter(Mandatory)]
    [string]$analysisServicesPassword,
	[string]$analysisServicesServer = "localhost"
)

Import-Module -Name SqlServer
$ErrorActionPreference = "Stop"

$SECURE_PASSWORD = ConvertTo-SecureString $analysisServicesPassword -AsPlainText -Force
$CREDENTIAL = New-Object System.Management.Automation.PSCredential ($analysisServicesUsername, $SECURE_PASSWORD)

Invoke-ProcessASDatabase -Server $analysisServicesServer -RefreshType Full -DatabaseName "$environment" -Credential $CREDENTIAL
