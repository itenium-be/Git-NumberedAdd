function Git-NumberedAdd {
	$fileInfos = Parse-GitIndexes $args
	if (-not $fileInfos) {
		return
	}

	$files = $fileInfos | % {$_.file}
	git add $files -v
}
