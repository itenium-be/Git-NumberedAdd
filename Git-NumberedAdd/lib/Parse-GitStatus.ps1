##############################################################################
#.SYNOPSIS
# Invokes `git status -s` and parses the result into object/array of objects
# Called by Git-NumberedStatus
#
#.DESCRIPTION
# Output looks like:
#
# @{
#	state=M(odified), A(dded), R(enamed)
#	file=The filename as ouputted by git status
#	staged=$true for staging area, $false for working directory change
#	fullPath=The full path
#	relativePath=Relative path to current pwd
#	oldFile=The original filename in case of a staged rename
# }
##############################################################################
function Parse-GitStatus($includeNumstat = $false, $extraArgs) {
	$hasStaged = $false
	$hasWorkingDir = $false

	$workingDir = Get-Location
	$gitRootdir = Get-GitRootLocation
	# write-host "workingDir=$workingDir"
	# write-host "gitRootdir=$gitRootdir"

	# ATTN: git status --porcelain returns paths relative from the repository root folder
	#       git status -s *could* change in the future but returns paths relative to pwd.

	$allArgs = @('status', '-s')
	if ($extraArgs) { $allArgs += $extraArgs }
	$allFiles = Invoke-Git @allArgs | % {
		$oldFilename = $null
		$relativePath = $_.Substring(3).Replace("`"", "")

		if ($relativePath -match " -> ") {
			$oldFilename = $relativePath.Substring(0, $relativePath.IndexOf(" -> "))
			$relativePath = $relativePath.Substring($relativePath.IndexOf(" -> ") + 4)
		}
		# write-host "relativePath: $relativePath"
		$fullPath = Join-Path $workingDir $relativePath
		# write-host "fullPath: $fullPath"
		$fullPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($fullPath)
		# write-host "fullPath2: $fullPath"
		$gitRootPath = $fullPath.Substring($gitRootdir.ToString().Length + 1)

		$relativePath = Quote-Path $relativePath
		$fullPath = Quote-Path $fullPath
		$gitRootPath = Quote-Path $gitRootPath

		# write-host "RELATIVE=$relativePath     FULL=$fullPath     GIT_ROOT=$gitRootPath"
		$returns = @()

		$staged = $_[0] -ne " " -and $_[0] -ne "?"
		if ($staged) {
			$hasStaged = $true
			$returns += @{
				state=$_[0];
				file=$gitRootPath;
				staged=$true;
				fullPath=$fullPath;
				relativePath=$relativePath;
				oldFile=$oldFilename;
			}
		}

		$isWorkingDir = $_[1] -ne " "
		if ($isWorkingDir) {
			$hasWorkingDir = $true
			$state = If ($_[1] -eq "?") {"A"} Else {$_[1]}
			$returns += @{
				state=$state;
				file=$gitRootPath;
				staged=$false;
				fullPath=$fullPath;
				relativePath=$relativePath;
			}
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


function Quote-Path($path) {
	if ($path.Contains(" ")) {
		return "`"$path`""
	}
	return $path
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
			$match = $line | Select-String -Pattern "warning: (?<from>\w+) will be replaced by (?<to>\w+) in (?<file>.*)\.|warning: in the working copy of '(?<file>.*)', (?<from>\w+) will be replaced by (?<to>\w+) the next time Git touches it"

			if ($match) {
				$fromEol = $match.matches[0].groups['from']
				$toEol = $match.matches[0].groups['to']
				$fileName = $match.matches[0].groups['file'].Value.Replace('/', '\')
				$matchingStatus = $allFiles | Where {$_.file -eq $fileName}
				if ($matchingStatus) {
					$matchingStatus | Add-Member -NotePropertyName 'lineEndings' -NotePropertyValue "$fromEol -> $toEol" -Force
				}
			}
		}
	}


	$numstatResult = $numstatResult | ? { $_ -isnot [System.Management.Automation.ErrorRecord] }
	$numstatResult | % {
		# Output format: +++ `t --- `t fileName
		$numstat = $_.Trim().Split("`t")
		$file = Quote-Path $numstat[2]
		$numstat = @{file=$file;added=$numstat[0];deleted=$numstat[1]}
		$matchingStatus = $allFiles | Where {$_.staged -eq $staged -and $numstat.file -eq $_.file}

		if ($matchingStatus) {
			$matchingStatus.added = $numstat.added
			$matchingStatus.deleted = $numstat.deleted
		}
	}
}
