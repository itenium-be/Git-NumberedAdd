##############################################################################
#.SYNOPSIS
# `git checkout` the indexes passed as $args in the working directory
##############################################################################
function Git-NumberedCheckout {
	$fileInfos = Parse-GitIndexes $args 'workingDir'
	if (-not $fileInfos) {
		return
	}

	$toCheckout = $fileInfos | ForEach-Object {$_.fullPath.Trim('"')}
	git checkout HEAD @($toCheckout)
}
