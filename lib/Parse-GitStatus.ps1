function Parse-GitStatus($includeNumstat = $false, $extraArgs) {
	$hasStaged = $false
	$hasWorkingDir = $false

	$allFiles = Invoke-Git status --porcelain $extraArgs | % {
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
