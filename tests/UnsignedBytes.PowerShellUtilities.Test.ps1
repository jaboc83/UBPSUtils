#region Test Functions
Function Test-NewFolderIfNotExists {
	## ARRANGE
	$testDirs = @("./TestDirA/","./TestDirB/")
	$testDirs | % { If (Test-Path $_) { Throw "$_ already exists" } }

	## ACT
	New-FolderIfNotExists $testDirs | Write-Verbose

	## ASSERT
	$testDirs | % { If (-not (Test-Path $_)) { Throw "$_ was not created." } }

	# cleanup
	$testDirs | % { If (Test-Path $_) { Remove-Item $_ } }

}

Function Test-RemoveItemIfExists {
	## ARRANGE
	$testDirs = @("./TestDirA/","./TestDirB/")
	New-FolderIfNotExists $testDirs | Write-Verbose

	## ACT
	$testDirs | Remove-ItemIfExists

	## ASSERT
	$testDirs | % { If (Test-Path $_) { Throw "$_ was not removed." } }
}
#endregion

#region Run Tests
$ErrorActionPreference = "Stop"
Test-NewFolderIfNotExists
Test-RemoveItemIfExists

#endregion
