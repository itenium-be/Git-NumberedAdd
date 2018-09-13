$global:gitStatusNumbers = @{
	stagingArea=$null;
	workingDir=$null;

	stagedColor='Green';
	addedColor='Blue';
	modifiedColor='Yellow';
	deletedColor='DarkMagenta';
	renamedColor='Yellow';

	includeNumstat=$true;
}


Set-Alias gs Git-NumberedStatus
Set-Alias ga Git-NumberedAdd
Set-Alias gd Git-NumberedDiff
Set-Alias grs Git-NumberedReset
Set-Alias gn Git-GetFileNameByIndex


# Let's keep things simple and don't do the following:
# - Keep track of added/reset files and use diff --cached to keep gd working
# - Staged file can be added again after a grs ('ga -3' !! collides with existing usage)


function Invoke-Git {
	# Exists solely for mocking purposes
	& git $args
}


function Git-GetFileNameByIndex($index) {
	return $global:gitStatusNumbers.workingDir[$index].file
}


function Add-GitNumstat($allFiles, $staged) {
	if ($staged) {
		$numstatResult = Invoke-Git diff --numstat --cached
	} else {
		$numstatResult = Invoke-Git diff --numstat
	}

	$numstatResult | % {
		$numstat = $_.Trim().Split("`t")
		$numstat = @{file=$numstat[2];added=$numstat[0];deleted=$numstat[1]}
		$matchingStatus = $allFiles | Where {$_.staged -eq $staged -and $numstat.file -eq $_.file}

		if ($matchingStatus) {
			$matchingStatus.added = $numstat.added
			$matchingStatus.deleted = $numstat.deleted
		}
	}
}


function Parse-GitStatus($includeNumstat = $false) {
	$hasStaged = $false
	$hasWorkingDir = $false

	$allFiles = Invoke-Git status -s | % {
		$file = $_.Substring(3)

		$returns = @()

		$staged = $_[0] -ne " " -and $_[0] -ne "?"
		if ($staged) {
			$hasStaged = $true
			$returns += @{state=$_[0];file=$file;staged=$true}
		}

		$workingDir = $_[1] -ne " "
		if ($workingDir) {
			$hasWorkingDir = $true
			$state = If ($_[1] -eq "?") {"A"} Else {$_[1]}
			$returns += @{state=$state;file=$file;staged=$false}
		}
		return $returns

	} | % {$_}


	# Include +/- lines for all files
	if ($includeNumstat) {
		if ($hasWorkingDir) {
			Add-GitNumstat $allFiles $false
		}

		if ($hasStaged) {
			Add-GitNumstat $allFiles $true
		}
	}

	return $allFiles
}


function Get-FileInfoFormat($maxAdded, $maxDeleted, $fileInfo) {
	if ($maxAdded -ne $null) {
		if ($fileInfo.added -ne $null) {
			return "{0,3}  {1}  {2,$maxAdded} {3,$maxDeleted}  {4}" -f $index,$fileInfo.state,"+$($fileInfo.added)","-$($fileInfo.deleted)",$fileInfo.file
		} else {
			return "{0,3}  {1}  {2,$maxAdded} {3,$maxDeleted}  {4}" -f $index,$fileInfo.state,"","",$fileInfo.file
		}

	} else {
		return "{0,3}  {1}  {2}" -f $index,$fileInfo.state,$fileInfo.file
	}
}


function Git-NumberedStatus() {
	$config = $global:gitStatusNumbers
	$allFiles = Parse-GitStatus $config.includeNumstat

	if ($config.includeNumstat) {
		$maxAdded = ($allFiles | ? {$_.added -ne $null} | % {$_.added.ToString().Length} |  Measure-Object -Maximum).Maximum + 1
		$maxDeleted = ($allFiles | ? {$_.deleted -ne $null} | % {$_.deleted.ToString().Length} |  Measure-Object -Maximum).Maximum + 1
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


function Validate-GitIndexes($indexes) {
	if (-not $global:gitStatusNumbers.workingDir) {
		Write-Host "First run Git-NumberedStatus"
		return $false
	}

	if ($indexes.length -eq 0 -or $indexes[0] -eq $null) {
		Write-Host "No arguments? Usage:"
		Write-Host "Add the first file: 'Git-NumberedAdd 0'"
		Write-Host "Add the first 3 files: 'Git-NumberedAdd 0 1 2' or 'Git-NumberedAdd 0-2' or 'Git-NumberedAdd -3' or 'Git-NumberedAdd 012'"
		Write-Host "Add all files starting from 2: 'Git-NumberedAdd +1'"
		return $false
	}

	return $true
}


function Parse-GitIndexes($argIndexes, $lookIn = "workingDir") {
	if (-not (Validate-GitIndexes $argIndexes)) {
		return
	}

	$allFiles = switch($lookIn) {
		'workingDir' {$global:gitStatusNumbers.workingDir; break}
		'stagingArea' {$global:gitStatusNumbers.stagingArea; break}
	}


	if ($allFiles.length -lt 10 `
		-and ([string]$argIndexes).Length -gt 1 `
		-and [string]$argIndexes -match '^[0-9]+$'
	) {
		# Add by many 1 digit indexes (ex: 035 == 0, 3 and 5)
		$argIndexes = ([string]$argIndexes).ToCharArray()
	}

	$indexes = @()
	foreach ($arg in $argIndexes) {
		if ($arg -match '^\d+-\d+$') {
			# Add by range
			$begin = ($arg -split '-')[0]
			$end = ($arg -split '-')[1]
			$indexes += $begin..$end

		} elseif ($arg[0] -eq '-' -or $arg[0] -eq '+') {
			# All before/after
			$beginOrStart = [int]$arg.Substring(1)

			if ($arg[0] -eq '-') {
				# Add all before
				$allBefore = $beginOrStart - 1
				$indexes += 0..$allBefore

			} else {
				# Add all after
				$indexes += ($beginOrStart + 1)..($allFiles.length - 1)
			}

		} elseif ([int32]::TryParse($arg, [ref]$index)) {
			# Add by index
			$indexes += $index

		} else {
			Write-Host "Unparseable argument '$arg'" -ForegroundColor DarkMagenta
		}
	}

	return $indexes | % {$_} | ? {
		if ($_ -ge $allFiles.length) {
			Write-Host "$_ is outside of the boundaries of Git-NumberedStatus (Length: $($allFiles.length))" -ForegroundColor DarkMagenta
			return $false
		}
		return $true
	} | % { $allFiles[$_] }
}


function Git-NumberedAdd {
	$fileInfos = Parse-GitIndexes $args
	if (-not $fileInfos) {
		return
	}

	$files = $fileInfos | % {$_.file}
	git add $files -v
}



function Git-NumberedDiff {
	if ($args.length -eq 0 -or $args[0] -eq $null) {
		$args = @("0-$($global:gitStatusNumbers.workingDir.length - 1)")
	}

	$fileInfos = Parse-GitIndexes $args
	if (-not $fileInfos) {
		return
	}

	# git add -N, --intent-to-add
	# so that new files are shown in the diff
	$newFiles = $fileInfos | ? {$_.state -eq 'A'} | % {$_.file}
	if ($newFiles) {
		Write-Host "git add --intent-to-add $newFiles"
		git add -Nv $newFiles
	}

	# Filter deleted files from diff (git doesn't like it)
	$files = $fileInfos | ? {$_.state -ne 'D'} | % {$_.file}
	git diff $files
}


function Git-NumberedReset {
	$fileInfos = Parse-GitIndexes $args 'stagingArea'
	if (-not $fileInfos) {
		return
	}

	$toReset = $fileInfos | % {$_.file}
	git reset HEAD $toReset
}
