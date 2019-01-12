function Git-NumberedAssumed {
	$fileInfos = Parse-GitIndexes $args 'workingDir'
	if (-not $fileInfos) {
		return
	}

	$files = $fileInfos | % {$_.fullPath}
	git update-index --assume-unchanged $files
}


# To NoAssume we need to list the assumed files first

$global:assumedFiles = @()

function Git-ListAssumed {
	$files = (git ls-files -v) | Where-Object { $_.StartsWith("h") } | % { $_.Substring(2) }
	$index = 0
	$files | % {
		Write-Host "$index $_"
		$global:assumedFiles += $_
		$index++
	}
}

function Git-NumberedNoAssumed {
	$file = $global:assumedFiles[$args]
	git update-index --no-assume-unchanged $file
}
