function Parse-GitIndexes($argIndexes, $lookIn = "workingDir") {
	if (-not (Validate-GitIndexes $argIndexes)) {
		return
	}

	$allFiles = switch($lookIn) {
		'workingDir' {$global:gitStatusNumbers.workingDir; break}
		'stagingArea' {$global:gitStatusNumbers.stagingArea; break}
	}
	if ($allFiles.length -eq 1) {
		$allFiles = @($allFiles)
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


function Validate-GitIndexes($indexes) {
	if (-not $global:gitStatusNumbers.workingDir -and -not $global:gitStatusNumbers.stagingArea) {
		Write-Host "First run Git-NumberedStatus"
		return $false
	}

	if ($indexes.length -eq 0 -or $indexes[0] -eq $null) {
		Write-Host "No arguments? Usage:"
		Write-Host "Add the first file: 'Git-NumberedAdd 0'"
		Write-Host "Add the first 3 files: 'Git-NumberedAdd 0 1 2' or 'Git-NumberedAdd 0-2' or 'Git-NumberedAdd -3' or 'Git-NumberedAdd 012'"
		Write-Host "Add all files starting from 2: 'Git-NumberedAdd +1'"
		Write-Host
		Write-Host "A tutorial: https://itenium.be/blog/productivity/git-numbered-add-for-powershell"
		return $false
	}

	return $true
}