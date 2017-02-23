#region Functions
Function Export-ZipFile
{
	<#
	.SYNOPSIS
		Unzip a file
	.DESCRIPTION
		Unzips the specified archive to the destination indicated
	.PARAMETER $FilePath
		Path to the archive file
	.PARAMETER $Destination
		Path to place the unzipped files
	.PARAMETER $ContainingFolder
		If this parameter is set the files will be unzipped into a folder within
		the destination with the folder name indicated otherwise they will be unzipped
		directly into the destination path.
	.EXAMPLE
		Export-ZipFile -FilePath ./archive.zip -Destination ./DestinationDir/
		Unzip a file's contents into the destination directory
	.EXAMPLE
		Export-ZipFile -FilePath ./archive.zip -Destination ./DestinationDir/ -ContainingFolder -MyStuff
		Unzip a file's contents into the folder ./DestinationDir/MyStuff/
	#>
	[CmdletBinding(SupportsShouldProcess=$True)]
	param (
		[Parameter(
			Mandatory=$True,
			ValueFromPipeline=$True,
			ValueFromPipelineByPropertyName=$True
		)]
		[ValidateScript({ Test-Path $_ })]
		[ValidatePattern("\.zip$")]
			[string] $FilePath,
		[Parameter(
			Mandatory=$True
		)]
		[ValidateScript({ Test-Path $_ })]
			[string] $Destination,
			[string] $ContainingFolder
	)
	BEGIN {
		$shell = New-Object -com shell.application
		# Default destination is not in a containing folder
		$finalDestination = $Destination

		If ($ContainingFolder -ne $null) {
			Write-Verbose "Unzipping using a containing folder"
			$containingFolderPath = (Join-Path $Destination $ContainingFolder)
			If ((Test-Path $containingFolderPath) -eq $False) {
				New-Item -Type Directory $containingFolderPath -WhatIf:([bool]$WhatIfPreference.IsPresent) | Out-Null
			}
			$finalDestination = $containingFolderPath
		}
		if ($pscmdlet.ShouldProcess($finalDestination, "Validating destination exists")) {
			$finalDestination = ((Resolve-Path $finalDestination) | Select -ExpandProperty Path)
		}
	}
	PROCESS {
		$zip = $shell.NameSpace(((Resolve-Path $FilePath) | Select -ExpandProperty Path))

		Write-Verbose "Attempting to unzip $zip"
		ForEach ($item in $zip.items()) {
			Write-Debug $item.Path
			If ($pscmdlet.ShouldProcess($item.Path, "Copy into $finalDestination")) {
				$shell.NameSpace($finalDestination).CopyHere($item)
			}
		}
	}
	END {
		Write-Verbose "Files unzipped to destination $finalDestination"
	}

}

Function Remove-ItemIfExists {
	<#
	.SYNOPSIS
		Remove a file / folder if it exists
	.DESCRIPTION
		Removes the specified file / folder if it exists, otherwise it does
		nothing.
	.PARAMETER $Paths
		File / folder path(s) to remove
	.EXAMPLE
		Remove-ItemIfExists -Item ./test.txt
		Remove a file
	.EXAMPLE
		Remove-ItemIfExists -Item ./bin,./obj
		Remove a set of directories
	.EXAMPLE
		Get-ChildItem *.log | Remove-ItemIfExists
		Remove all the log files in the current directory
	#>
	[CmdletBinding(SupportsShouldProcess=$True)]
	param (
		[Parameter(
			Mandatory=$True,
			Position=0,
			ValueFromPipeline=$True,
			ValueFromPipelineByPropertyName=$True
		)]
			[string[]]$Paths
	)
	PROCESS {

		# Check all paths passed in
		ForEach ($path in $Paths) {
			If (Test-Path $path) {
				Remove-Item (Resolve-Path ($path)) -Recurse -Force -WhatIf:([bool]$WhatIfPreference.IsPresent)
			}
		}
	}
}

Function New-FolderIfNotExists {
	<#
	.SYNOPSIS
		Create a folder if it doesn't exist yet
	.DESCRIPTION
		This function will check if the specified folder
		exists and if it doesn't it will create the folder
	.PARAMETER $Paths
		The path to the folder to be created
	.EXAMPLE
		New-FolderIfNotExists ./TestFolder/
		Add a folder
	.EXAMPLE
		New-FolderIfNotExists ./TestFolderA/,./TestFolderB/
		Add a collection of folders
	#>
	[CmdletBinding(SupportsShouldProcess=$True)]
	param (
		[Parameter(
			Mandatory=$True,
			Position=0,
			ValueFromPipeline=$True,
			ValueFromPipelineByPropertyName=$True
		)]
			[string[]]$Paths
	)
	PROCESS {
		ForEach ($path in $Paths) {
			If (-not (Test-Path $path)) {
				New-Item -Type Directory $path -WhatIf:([bool]$WhatIfPreference.IsPresent)
			}
		}
	}
}

#endregion

#region Module Exports
Export-ModuleMember -Function Export-ZipFile
Export-ModuleMember -Function Remove-ItemIfExists
Export-ModuleMember -Function New-FolderIfNotExists
#endregion
