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

	if ([string]$argIndexes -match '^([0-9]+)(?: (\D+))?$' `
		-and ($Matches[0].Length -gt 1) `
		-and ($allFiles.length -lt 11 -or [int]$Matches[0] -ge $allFiles.length)
	) {
		# Add by many 1 digit indexes (ex: 035 == 0, 3 and 5)
		$argIndexes = $Matches[1].ToCharArray()
		$commitMsg = $Matches[2]
	}

	$indexes = @()
	for ($counter = 0; $counter -lt $argIndexes.Length; $counter++) {
		$arg = $argIndexes[$counter]
		$index = $null; # Initialization for [ref] usage below (CI complains otherwise)

		if ($arg -match '^\d+-\d+$') {
			# Add by range (ex: 3-5)
			$begin = ($arg -split '-')[0]
			$end = ($arg -split '-')[1]
			$indexes += $begin..$end

		} elseif ($arg[0] -eq '-' -or $arg[0] -eq '+') {
			# All before/after (ex: -3 or +5)
			$beginOrStart = [int]$arg.Substring(1)

			if ($arg[0] -eq '-') {
				# Add all before (ex: -3 == 0, 1, 2)
				$allBefore = $beginOrStart - 1
				$indexes += 0..$allBefore

			} else {
				# Add all after (ex: +3 == 4, 5, ...)
				$indexes += ($beginOrStart + 1)..($allFiles.length - 1)
			}

		} elseif ([int32]::TryParse($arg, [ref]$index)) {
			# Add by index (ex: 3, 15)
			$indexes += $index

		} elseif ($argIndexes.Length -gt 1 -and $argIndexes.Length -eq $counter + 1) {
			# Last argument: commit message
			$commitMsg = $arg

		} else {
			Write-Host "Unparseable argument '$arg'" -ForegroundColor DarkMagenta
		}
	}

	$return = $indexes | Where-Object {
		if ($_ -ge $allFiles.length) {
			Write-Host "$_ is outside of the boundaries of Git-NumberedStatus (Length: $($allFiles.length))" -ForegroundColor DarkMagenta
			return $false
		}
		return $true
	} | ForEach-Object { $allFiles[$_] }

	if ($commitMsg) {
		if ($return -is [array]) {
			$return += $commitMsg
		} else {
			$return = $return,$commitMsg
		}
	}

	return $return
}


function Validate-GitIndexes($indexes) {
	if (-not $global:gitStatusNumbers.workingDir -and -not $global:gitStatusNumbers.stagingArea) {
		Write-Host "First run Git-NumberedStatus (gs)"
		Write-Host
		Write-Host "Run Git-NumberedHelp (gnh) if you have no clue how to start"
		Write-Host "A tutorial: https://itenium.be/blog/productivity/git-numbered-add-for-powershell"
		return $false
	}

	if ($indexes.length -eq 0 -or $null -eq $indexes[0]) {
		Write-Host "No arguments? Usage:"
		Write-Host "Add the first file: 'Git-NumberedAdd 0'"
		Write-Host "Add the first 3 files: 'Git-NumberedAdd 0 1 2' or 'Git-NumberedAdd 0-2' or 'Git-NumberedAdd -3' or 'Git-NumberedAdd 012'"
		Write-Host "Add all files starting from 2: 'Git-NumberedAdd +1'"
		Write-Host
		Write-Host "Run Git-NumberedHelp (gnh) for a list of all functions"
		Write-Host "A tutorial: https://itenium.be/blog/productivity/git-numbered-add-for-powershell"
		return $false
	}

	return $true
}
