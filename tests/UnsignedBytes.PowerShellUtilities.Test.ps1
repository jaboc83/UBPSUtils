$ErrorActionPreference = "Stop"
$scriptPath = Split-Path -LiteralPath $(if ($PSVersionTable.PSVersion.Major -ge 3) { $PSCommandPath } else { & { $MyInvocation.ScriptName } })
$src = "$scriptPath/../src"

#region Test Functions
Function Test-NewFolderIfNotExists {
	## ARRANGE
	$testDirs = @("./TestDirA/","./TestDirB/")
	$testDirs | % { If (Test-Path $_) { Throw "$_ already exists" } }

	## ACT
	New-FolderIfNotExists $testDirs -WhatIf | Write-Verbose
	New-FolderIfNotExists $testDirs | Write-Verbose
	New-FolderIfNotExists $testDirs | Write-Verbose
	New-FolderIfNotExists $testDirs -WhatIf | Write-Verbose

	## ASSERT
	$testDirs | % { If (-not (Test-Path $_)) { Throw "$_ was not created." } }
	Write-Output "New-FolderIfNotExists Tests Complete."

	# cleanup
	$testDirs | % { If (Test-Path $_) { Remove-Item $_ } }

}

Function Test-RemoveItemIfExists {
	## ARRANGE
	$testDirs = @("./TestDirA/","./TestDirB/")
	New-FolderIfNotExists $testDirs | Write-Verbose

	## ACT
	$testDirs | Remove-ItemIfExists -WhatIf
	$testDirs | Remove-ItemIfExists
	$testDirs | Remove-ItemIfExists -WhatIf
	Write-Output "Remove-ItemIfExists Tests Complete."

	## ASSERT
	$testDirs | % { If (Test-Path $_) { Throw "$_ was not removed." } }
}

Function Test-ExportZipFile {
	## ARRANGE
	$file = './tests/test.zip'
	$dest = './tests/'
	$containingFolder = 'testUnzipped'

	## ACT
	Export-ZipFile $file $dest $containingFolder -WhatIf
	Export-ZipFile $file $dest $containingFolder
	Export-ZipFile $file $dest $containingFolder -WhatIf

	## ASSERT
	If (-not (Test-Path $dest)) {
		Throw "Destination was not created"
	}
	If ((Get-ChildItem "$dest\$containingFolder\*.test").Count -ne 2) {
		Throw "Files unzipped incorrectly"
	}
	Write-Output "Export-ZipFile Tests Complete."

	# cleanup
	Remove-Item "$dest/$containingFolder" -Force -Recurse
}
#endregion

Import-Module "$src/UnsignedBytes.PowerShellUtilities.psm1"

#region Run Tests
Test-NewFolderIfNotExists
Test-RemoveItemIfExists
Test-ExportZipFile
#endregion

Remove-Module "UnsignedBytes.PowerShellUtilities"
