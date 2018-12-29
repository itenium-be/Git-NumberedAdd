function Git-NumberedDiff {
	if ($args.length -eq 0 -or $args[0] -eq $null) {
		$args = @("0-$($global:gitStatusNumbers.workingDir.length - 1)")
	}

	$fileInfos = Parse-GitIndexes $args
	if (-not $fileInfos) {
		return
	}

	# git add -N, --intent-to-add
	# so that new files are shown in the diff
	$newFiles = $fileInfos | ? {$_.state -eq 'A'} | % {$_.file}
	if ($newFiles) {
		Write-Host "git add --intent-to-add $newFiles"
		git add -Nv $newFiles
	}

	# Filter deleted files from diff (git doesn't like it)
	$files = $fileInfos | ? {$_.state -ne 'D'} | % {$_.file}
	git diff $files
}
