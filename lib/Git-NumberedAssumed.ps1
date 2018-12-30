function Git-NumberedAssumed {
	$fileInfos = Parse-GitIndexes $args 'workingDir'
	if (-not $fileInfos) {
		return
	}

	$files = $fileInfos | % {$_.file}
	git update-index --assume-unchanged $files
}



# This would actually need to do numbered display of assumed files...
# function Git-NumberedNoAssumed {
# 	$fileInfos = Parse-GitIndexes $args 'workingDir'
# 	if (-not $fileInfos) {
# 		return
# 	}

# 	$files = $fileInfos | % {$_.file}
# 	git update-index --no-assume-unchanged $files
# }
