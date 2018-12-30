function Git-NumberedSetLocation {
	$fileInfos = Parse-GitIndexes $args 'workingDir'
	if (-not $fileInfos) {
		return
	}

	$path = (get-item $fileInfos.file).Directory.FullName

	Push-Location $path
	# Use Pop-Location (alias: popd) to go back to where you came from
}
