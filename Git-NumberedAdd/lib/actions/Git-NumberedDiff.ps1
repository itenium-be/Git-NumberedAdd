##############################################################################
#.SYNOPSIS
# `git diff` the indexes passed as $args in the working directory
##############################################################################
function Git-NumberedDiff {
	if ($args.length -eq 0 -or $null -eq $args[0]) {
		$args = @("0-$($global:gitStatusNumbers.workingDir.length - 1)")
	}

	$fileInfos = Parse-GitIndexes $args 'workingDir'
	if (-not $fileInfos) {
		return
	}

	# git add -N, --intent-to-add
	# so that new files are shown in the diff
	$newFiles = $fileInfos | Where-Object {$_.state -eq 'A'} | ForEach-Object {$_.fullPath.Trim('"')}
	if ($newFiles) {
		git add -Nv @($newFiles)
	}

	# Filter deleted files from diff (git doesn't like it)
	$files = $fileInfos | Where-Object {$_.state -ne 'D'} | ForEach-Object {$_.fullPath.Trim('"')}
	git diff @($files)
}


##############################################################################
#.SYNOPSIS
# `git diff --cached` the indexes passed as $args in the working directory
##############################################################################
function Git-NumberedDiffCached {
	if ($args.length -eq 0 -or $null -eq $args[0]) {
		if ($global:gitStatusNumbers.stagingArea.length -eq 0) {
			Write-Host "Staging area is empty."
			return
		}
		$args = @("0-$($global:gitStatusNumbers.stagingArea.length - 1)")
	}

	$fileInfos = Parse-GitIndexes $args 'stagingArea'
	if (-not $fileInfos) {
		return
	}

	$files = $fileInfos | ForEach-Object {$_.fullPath.Trim('"')}
	git diff --cached @($files)
}
