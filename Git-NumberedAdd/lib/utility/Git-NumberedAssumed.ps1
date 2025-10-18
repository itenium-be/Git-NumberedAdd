# ATTN: This file is 2x the same code (assumeUnchanged & skipWorktree)


##############################################################################
#.SYNOPSIS
# `git update-index --assume-unchanged` the indexes passed as $args in the working directory
##############################################################################
function Git-NumberedAssumed {
	$fileInfos = Parse-GitIndexes $args 'workingDir'
	if (-not $fileInfos) {
		return
	}

	$files = $fileInfos | ForEach-Object {$_.fullPath.Trim('"')}
	git update-index --assume-unchanged @($files)
}


# To NoAssume we need to list the assumed files first

$global:assumedFiles = @()


##############################################################################
#.SYNOPSIS
# Displays all currently git assumed files with indexes to be used by Git-NumberedUnassumed
##############################################################################
function Git-ListAssumed {
	$files = (git ls-files -v) | Where-Object { $_.StartsWith("h") } | ForEach-Object { $_.Substring(2) }
	$index = 0
	$files | ForEach-Object {
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
	if (-not $file) {
		Write-Host "Couldn't find hidden file with index $args"
	}
	git update-index --no-assume-unchanged $file
}









##############################################################################
#.SYNOPSIS
# `git update-index --skip-worktree` the indexes passed as $args in the working directory
##############################################################################
function Git-NumberedHidden {
	$fileInfos = Parse-GitIndexes $args 'workingDir'
	if (-not $fileInfos) {
		return
	}

	$files = $fileInfos | ForEach-Object {$_.fullPath.Trim('"')}
	git update-index --skip-worktree @($files)
}


# To Unhide we need to list the hidden files first

$global:hiddenFiles = @()


##############################################################################
#.SYNOPSIS
# Displays all currently git skip worktree files with indexes to be used by Git-NumberedHidden
##############################################################################
function Git-ListHidden {
	$files = (git ls-files -v) | Where-Object { $_.StartsWith("S") } | ForEach-Object { $_.Substring(2) }
	$index = 0
	$files | ForEach-Object {
		Write-Host "$index $_"
		$global:hiddenFiles += $_
		$index++
	}
}


##############################################################################
#.SYNOPSIS
# Git unhides a single index passed as $args as displayed by Git-ListHidden
##############################################################################
function Git-NumberedUnhidden {
	$file = $global:hiddenFiles[$args]
	if (-not $file) {
		Write-Host "Couldn't find hidden file with index $args"
	}
	git update-index --no-skip-worktree $file
}
