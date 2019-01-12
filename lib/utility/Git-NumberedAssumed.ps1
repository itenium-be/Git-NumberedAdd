##############################################################################
#.SYNOPSIS
# `git update-index --assume-unchanged` the indexes passed as $args in the working directory
##############################################################################
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


##############################################################################
#.SYNOPSIS
# Displays all currently git assumed files with indexes to be used by Git-NumberedUnassumed
##############################################################################
function Git-ListAssumed {
	$files = (git ls-files -v) | Where-Object { $_.StartsWith("h") } | % { $_.Substring(2) }
	$index = 0
	$files | % {
		Write-Host "$index $_"
		$global:assumedFiles += $_
		$index++
	}
}


##############################################################################
#.SYNOPSIS
# Git unassumes a single index passed as $args as displayed by Git-ListAssumed
##############################################################################
function Git-NumberedUnassumed {
	$file = $global:assumedFiles[$args]
	git update-index --no-assume-unchanged $file
}
