##############################################################################
#.SYNOPSIS
# Calls Parse-GitStatus and displays the results
#
#.DESCRIPTION
# Output looks like:
# ---------------------
# Staged files:
#   0  M file0
#   1  A file1
#
# Working directory:
#   0  M file0
# ---------------------
#
# Legend
# '0-1' are the indexes
# Status codes:
# - M: Modified
# - A: Added
# - D: deleted
# - R: Renamed
#
# Use Git-NumberedHelp for an overview of all actions and utilities
#
#.EXAMPLE
# Git-NumberedStatus
#
# And follow with:
# Git-NumberedAdd -3 5 6 8-10
# To add the files: 0, 1, 2, 5, 6, 8, 9 and 10
##############################################################################
function Git-NumberedStatus() {
	$config = $global:gitStatusNumbers
	$allFiles = Parse-GitStatus $config.includeNumstat ($args -Join " ")

	if ($config.includeNumstat) {
		$maxAdded = ($allFiles | Where-Object {$null -ne $_.added} | ForEach-Object {$_.added.ToString().Length} | Measure-Object -Maximum).Maximum + 1
		$maxDeleted = ($allFiles | Where-Object {$null -ne $_.deleted} | ForEach-Object {$_.deleted.ToString().Length} | Measure-Object -Maximum).Maximum + 1
	}

	$config.stagingArea = $allFiles | Where-Object staged
	if ($config.stagingArea.length) {
		Write-Host "Staged files:"
		$config.stagingArea | ForEach-Object {$index = -1}{
			$index++

			$output = Get-FileInfoFormat $maxAdded $maxDeleted $_
			Write-Host $output -ForegroundColor $config.stagedColor
		}
		Write-Host ""
	}


	$config.workingDir = @($allFiles | Where-Object {$_.staged -eq $false})
	if ($config.workingDir.length) {
		Write-Host "Working directory:"
		$config.workingDir | ForEach-Object {$index = -1}{
			$index++

			$color = switch($_.state) {
				'A' {$config.addedColor; break}
				'M' {$config.modifiedColor; break}
				'D' {$config.deletedColor; break}
				'R' {$config.renamedColor; break}
				default {'White'}
			}

			$output = Get-FileInfoFormat $maxAdded $maxDeleted $_
			Write-Host $output -ForegroundColor $color
		}
	}
}



function Get-FileInfoFormat($maxAdded, $maxDeleted, $fileInfo) {
	$file = switch($global:gitStatusNumbers.displayFilesAs) {
		'full-path' {$fileInfo.fullPath}
		'relative-path' {$fileInfo.relativePath}
		'gitroot-path' {$fileInfo.file}
	}

	if ($fileInfo.oldFile) {
		$file = "$($fileInfo.oldFile) -> $file"
	}

	if ($fileInfo.lineEndings) {
		$file = "$file ($($fileInfo.lineEndings))"
	}

	if ($null -ne $maxAdded) {
		if ($null -ne $fileInfo.added) {
			return "{0,3}  {1}  {2,$maxAdded} {3,$maxDeleted}  {4}" -f $index,$fileInfo.state,"+$($fileInfo.added)","-$($fileInfo.deleted)",$file
		} else {
			return "{0,3}  {1}  {2,$maxAdded} {3,$maxDeleted}  {4}" -f $index,$fileInfo.state,"","",$file
		}

	} else {
		return "{0,3}  {1}  {2}" -f $index,$fileInfo.state,$file
	}
}
