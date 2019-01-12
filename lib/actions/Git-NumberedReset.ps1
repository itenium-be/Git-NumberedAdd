##############################################################################
#.SYNOPSIS
# `git reset HEAD` the indexes passed as $args in the staging area
##############################################################################
function Git-NumberedReset {
	$fileInfos = Parse-GitIndexes $args 'stagingArea'
	if (-not $fileInfos) {
		return
	}

	$toReset = $fileInfos | % {$_.fullPath}
	git reset HEAD $toReset
}
