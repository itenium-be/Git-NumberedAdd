##############################################################################
#.SYNOPSIS
# `git add` the indexes passed as $args in the working directory
##############################################################################
function Git-NumberedAdd {
	$fileInfos = Parse-GitIndexes $args 'workingDir'
	if (-not $fileInfos) {
		return
	}

	$files = @()
	$commitMsg = $null
	foreach ($item in $fileInfos) {
		if ($item -is [string]) {
			$commitMsg = $item
		} else {
			$files += $item.FullPath.Trim('"')
		}
	}

	git add -v @files

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

	$files = $fileInfos | ForEach-Object {$_.fullPath.Trim('"')}
	git add @files -vp
}
