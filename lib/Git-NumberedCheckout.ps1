function Git-NumberedCheckout {
	$fileInfos = Parse-GitIndexes $args 'workingDir'
	if (-not $fileInfos) {
		return
	}

	$toCheckout = $fileInfos | % {$_.file}
	git checkout HEAD $toCheckout
}
