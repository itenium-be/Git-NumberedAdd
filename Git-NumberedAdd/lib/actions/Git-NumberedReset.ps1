##############################################################################
#.SYNOPSIS
# `git reset HEAD` the indexes passed as $args in the staging area
##############################################################################
function Git-NumberedReset {
	$fileInfos = Parse-GitIndexes $args 'stagingArea'
	if (-not $fileInfos) {
		return
	}

	$toReset = $fileInfos | ForEach-Object {$_.fullPath.Trim('"')}
	git reset HEAD @($toReset)
}
