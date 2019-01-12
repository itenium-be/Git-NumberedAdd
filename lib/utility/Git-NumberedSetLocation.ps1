##############################################################################
#.SYNOPSIS
# Navigate to the single index passed as $args in the working directory
#
#.DESCRIPTION
# Use Pop-Location (alias: popd) to go back to where you came from
##############################################################################
function Git-NumberedSetLocation {
	$fileInfos = Parse-GitIndexes $args 'workingDir'
	if (-not $fileInfos) {
		return
	}

	$path = (Get-ChildItem $fileInfos.fullPath).Directory.FullName

	Push-Location $path
}
