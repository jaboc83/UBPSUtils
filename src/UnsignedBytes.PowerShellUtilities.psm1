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
	[CmdletBinding()]
	[OutputType([void])]
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
				New-Item -Type Directory $containingFolderPath | Out-Null
			}
			$finalDestination = $containingFolderPath
		}
        $finalDestination = ((Resolve-Path $finalDestination) | Select -ExpandProperty Path)
	}
	PROCESS {
		$zip = $shell.NameSpace(((Resolve-Path $FilePath) | Select -ExpandProperty Path))

		Write-Verbose "Attempting to unzip $zip"
		ForEach ($item in $zip.items()) {
			Write-Debug $item.Path
			$shell.NameSpace($finalDestination).CopyHere($item)
		}
	}
	END {
		Write-Verbose "Files unzipped to destination $finalDestination"
	}

}
#endregion

#region Module Exports
Export-ModuleMember Export-ZipFile
#endregion
