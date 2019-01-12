function Parse-GitStatus($includeNumstat = $false, $extraArgs) {
	$hasStaged = $false
	$hasWorkingDir = $false

	$workingDir = Get-Location
	$gitRootdir = Get-GitRootLocation
	# write-host "workingDir=$workingDir"
	# write-host "gitRootdir=$gitRootdir"

	# ATTN: git status --porcelain returns paths relative from the repository root folder
	#       git status -s *could* change in the future but returns paths relative to pwd.
	$allFiles = Invoke-Git status -s $extraArgs | % {
		$relativePath = $_.Substring(3)
		$fullPath = Join-Path $workingDir $relativePath
		$fullPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($fullPath)
		# write-host "RELATIVE=$relativePath     FULL=$fullPath"
		$gitRootPath = $fullPath.Substring($gitRootdir.ToString().Length + 1)

		$returns = @()

		$staged = $_[0] -ne " " -and $_[0] -ne "?"
		if ($staged) {
			$hasStaged = $true
			$returns += @{state=$_[0];file=$gitRootPath;staged=$true;fullPath=$fullPath;relativePath=$relativePath}
		}

		$isWorkingDir = $_[1] -ne " "
		if ($isWorkingDir) {
			$hasWorkingDir = $true
			$state = If ($_[1] -eq "?") {"A"} Else {$_[1]}
			$returns += @{state=$state;file=$gitRootPath;staged=$false;fullPath=$fullPath;relativePath=$relativePath}
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
		$numstatResult = Invoke-Git diff --numstat --cached 2>&1
	} else {
		$numstatResult = Invoke-Git diff --numstat 2>&1
	}


	$eolWarnings = $numstatResult | ? { $_ -is [System.Management.Automation.ErrorRecord] }
	$eolWarnings | % {
		$line = $_.Exception.Message
		if ($line.StartsWith('The file will have its original line')) {
			# Ignore this one

		} elseif ($line.StartsWith('warning: ')) {
			# Add EOL notice
			$match = $line | Select-String -Pattern 'warning: (\w+) will be replaced by (\w+) in (.*)\.'
			$fromEol = $match.matches.groups[1]
			$toEol = $match.matches.groups[2]
			$fileName = $match.matches.groups[3].Value.Replace('/', '\')
			$matchingStatus = $allFiles | Where {$_.file -eq $fileName}
			if ($matchingStatus) {
				$matchingStatus.lineEndings = "$fromEol -> $toEol"
			}
		}
	}


	$numstatResult = $numstatResult | ? { $_ -isnot [System.Management.Automation.ErrorRecord] }
	$numstatResult | % {
		# Output format: +++ `t --- `t fileName
		$numstat = $_.Trim().Split("`t")
		$numstat = @{file=$numstat[2];added=$numstat[0];deleted=$numstat[1]}
		$matchingStatus = $allFiles | Where {$_.staged -eq $staged -and $numstat.file -eq $_.file}

		if ($matchingStatus) {
			$matchingStatus.added = $numstat.added
			$matchingStatus.deleted = $numstat.deleted
		}
	}
}
