function Parse-GitStatus($includeNumstat = $false, $extraArgs) {
	$hasStaged = $false
	$hasWorkingDir = $false

	$workingDir = (Get-Location).FullName

	Push-GitRootLocation
	$gitRootdir = (Get-Location).FullName


	# Pop-GitRootLocation

	# Resolve-Path -Relative $file

	# Start a git root
	# full-path = pwd + file
	# relative-gitroot = file
	# relative-path = (pwd - gitroot) + file

	# ATTN: git status --porcelain returns paths relative from the repository root folder
	#       git status -s *could* change in the future but returns paths relative to pwd.
	$allFiles = Invoke-Git status -s $extraArgs | % {
		$gitRootPath = $_.Substring(3)
		$fullPath = Join-Path $pwd $gitRootPath
		# $file = Resolve-Path $file

		# TODO: Can't use Resolve-Path: we can't do this with deleted files!

		$displayPath = switch($global:gitStatusNumbers.displayFilesAs) {
			'full-path' {$fullPath}
			'relative-path' {$gitRootPath}
			'relative-gitroot' {$gitRootPath}
		}

		# Write-Host ";displayPath=$displayPath"

		$returns = @()

		$staged = $_[0] -ne " " -and $_[0] -ne "?"
		if ($staged) {
			$hasStaged = $true
			# TODO: hier --> save fullPath & relative paths..?
			$returns += @{state=$_[0];file=$gitRootPath;staged=$true;displayPath=$displayPath}
		}

		$workingDir = $_[1] -ne " "
		if ($workingDir) {
			$hasWorkingDir = $true
			$state = If ($_[1] -eq "?") {"A"} Else {$_[1]}
			$returns += @{state=$state;file=$gitRootPath;staged=$false;displayPath=$displayPath}
		}
		return $returns

	} | % {$_}

	Pop-GitRootLocation


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
