function Git-NumberedAdd {
	$fileInfos = Parse-GitIndexes $args 'workingDir'
	if (-not $fileInfos) {
		return
	}

	$files = $fileInfos | % {$_.file}
	git add $files -v
}


function Git-NumberedAddPatch {
	$fileInfos = Parse-GitIndexes $args 'workingDir'
	if (-not $fileInfos) {
		return
	}

	$files = $fileInfos | % {$_.file}
	git add $files -vp
}
