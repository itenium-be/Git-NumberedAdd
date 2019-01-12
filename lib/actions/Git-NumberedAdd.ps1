##############################################################################
#.SYNOPSIS
# `git add` the indexes passed as $args in the working directory
##############################################################################
function Git-NumberedAdd {
	$fileInfos = Parse-GitIndexes $args 'workingDir'
	if (-not $fileInfos) {
		return
	}

	$files = $fileInfos | % {$_.fullPath}
	git add $files -v
}


##############################################################################
#.SYNOPSIS
# `git add --patch` the indexes passed as $args in the working directory
##############################################################################
function Git-NumberedAddPatch {
	$fileInfos = Parse-GitIndexes $args 'workingDir'
	if (-not $fileInfos) {
		return
	}

	$files = $fileInfos | % {$_.fullPath}
	git add $files -vp
}
