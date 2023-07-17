#Requires -Version 5.0
Set-StrictMode -Version Latest

# dot source the Tip.ps1 file to include our classes and enums.
. (Join-Path -Path $PSScriptRoot -ChildPath 'Tip.ps1')

[hashtable] $Tips = @{}

function Get-PowerShellTip
{
	[CmdletBinding()]
	[Alias('Get-PSTip', 'Get-Tip')]
	Param
	(
		[Parameter(Mandatory = $false)]
		[string] $TipId
	)

	[string] $tipsDirectoryPath = GetTipsDirectoryPath
	[string] $tipFilePath = GetRandomTipFilePath -tipsDirectoryPath $tipsDirectoryPath
	[string] $tip = Get-Content -Path $tipFilePath
	return $tip
}

function Write-PowerShellTip
{
	[CmdletBinding()]
	[Alias('Write-PSTip', 'Write-Tip', 'Tips')]
	Param
	(
		[Parameter(Mandatory = $false)]
		[string] $TipId
	)

	[string] $tip = Get-PowerShellTip -TipId $TipId
	Write-Host -Object $tip
}

function GetTipsDirectoryPath
{
	[string] $thisScriptsDirectoryPath = $PSScriptRoot
	[string] $tipsDirectoryPath = Join-Path -Path $thisScriptsDirectoryPath -ChildPath 'Tips'
	return $tipsDirectoryPath
}

function GetRandomTipFilePath
{
	Param
	(
		[Parameter(Mandatory = $true)]
		[string] $tipsDirectoryPath
	)

	[string] $tipFilePath = Get-ChildItem -Path $tipsDirectoryPath -Filter '*.json' |
		Get-Random -Count 1 |
		Select-Object -ExpandProperty FullName
	return $tipFilePath
}

# TODO: Move this tip aggregation into a build-time operation and dot-source just the one file at runtime.
function InitializeModule
{
	[string] $tipsDirectoryPath = GetTipsDirectoryPath
	[string[]] $tipFilePaths =
		Get-ChildItem -Path $tipsDirectoryPath -Filter '*.ps1' -Recurse |
		Select-Object -ExpandProperty FullName

	foreach ($tipFilePath in $tipFilePaths)
	{
		. $tipFilePath
	}
}
InitializeModule

Export-ModuleMember -Function Get-PowerShellTip
Export-ModuleMember -Alias 'Get-PSTip'
Export-ModuleMember -Alias 'Get-Tip'

Export-ModuleMember -Function Write-PowerShellTip
Export-ModuleMember -Alias 'Write-PSTip'
Export-ModuleMember -Alias 'Write-Tip'
Export-ModuleMember -Alias 'Tips'
