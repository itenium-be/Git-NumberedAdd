##############################################################################
#.SYNOPSIS
# `git checkout` the indexes passed as $args in the working directory
##############################################################################
function Git-NumberedCheckout {
	$fileInfos = Parse-GitIndexes $args 'workingDir'
	if (-not $fileInfos) {
		return
	}

	$toCheckout = $fileInfos | % {$_.fullPath}
	git checkout HEAD $toCheckout
}
