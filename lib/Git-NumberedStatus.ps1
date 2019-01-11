function Git-NumberedStatus() {
	$config = $global:gitStatusNumbers
	$allFiles = Parse-GitStatus $config.includeNumstat ($args -Join " ")

	if ($config.includeNumstat) {
		$maxAdded = ($allFiles | ? {$_.added -ne $null} | % {$_.added.ToString().Length} | Measure-Object -Maximum).Maximum + 1
		$maxDeleted = ($allFiles | ? {$_.deleted -ne $null} | % {$_.deleted.ToString().Length} | Measure-Object -Maximum).Maximum + 1
	}

	$config.stagingArea = $allFiles | Where staged
	if ($config.stagingArea.length) {
		Write-Host "Staged files:"
		$config.stagingArea | % {$index = -1}{
			$index++

			$output = Get-FileInfoFormat $maxAdded $maxDeleted $_
			Write-Host $output -ForegroundColor $config.stagedColor
		}
		Write-Host ""
	}


	$config.workingDir = @($allFiles | Where {$_.staged -eq $false})
	if ($config.workingDir.length) {
		Write-Host "Working directory:"
		$config.workingDir | % {$index = -1}{
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

	if ($maxAdded -ne $null) {
		if ($fileInfo.added -ne $null) {
			return "{0,3}  {1}  {2,$maxAdded} {3,$maxDeleted}  {4}" -f $index,$fileInfo.state,"+$($fileInfo.added)","-$($fileInfo.deleted)",$file
		} else {
			return "{0,3}  {1}  {2,$maxAdded} {3,$maxDeleted}  {4}" -f $index,$fileInfo.state,"","",$file
		}

	} else {
		return "{0,3}  {1}  {2}" -f $index,$fileInfo.state,$file
	}
}
