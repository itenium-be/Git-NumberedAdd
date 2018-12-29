function Git-NumberedReset {
	$fileInfos = Parse-GitIndexes $args 'stagingArea'
	if (-not $fileInfos) {
		return
	}

	$toReset = $fileInfos | % {$_.file}
	git reset HEAD $toReset
}
