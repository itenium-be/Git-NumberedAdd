##############################################################################
#.SYNOPSIS
# `git add` the indexes passed as $args in the working directory
##############################################################################
function Git-NumberedAdd {
	$fileInfos = Parse-GitIndexes $args 'workingDir'
	if (-not $fileInfos) {
		return
	}

	$files = $fileInfos | % {
		if ($_ -is [string]) {
			$commitMsg = $_
		} else {
			$_.fullPath
		}
	}
	# write-host "git add -v $files"
	git add -v $files


	if ($commitMsg) {
		git commit -m $commitMsg
	}
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
