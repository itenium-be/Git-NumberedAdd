. $PSScriptRoot\..\git-numbered.ps1


Describe 'Parse-GitStatus - with $global:gitStatusNumbers.displayFilesAs' {
	# $file0 = "TestDrive:\dir\file0"
	# New-Item -ItemType directory "TestDrive:\dir"
	# New-Item "$file0"

	# Mock Invoke-Git {
	# 	if (([string]$args).StartsWith("status")) {
	# 		" M $file0"
	# 	} else {
	# 		# git diff --numstat
	# 		"`t5`t3`t$file0"
	# 	}
	# }



	# It 'with "full-path"' {
	# 	Push-Location "TestDrive:\dir"
	# 	$global:gitStatusNumbers.displayFilesAs = 'full-path'

	# 	try {
	# 		$result = Parse-GitStatus $true
	# 	} finally {
	# 		Pop-Location
	# 	}

	# 	$result.displayPath | Should -Be $file0
	# }


	# It 'with "relative-path"' {
	# 	Push-Location "TestDrive:\dir"
	# 	$global:gitStatusNumbers.displayFilesAs = 'relative-path'

	# 	try {
	# 		$result = Parse-GitStatus $true
	# 	} finally {
	# 		Pop-Location
	# 	}

	# 	$result.displayPath | Should -Be ".\file0"
	# }


	# It 'with "relative-gitroot"' {
	# 	$global:gitStatusNumbers.displayFilesAs = 'relative-gitroot'

	# 	try {
	# 		$result = Parse-GitStatus $true
	# 	} finally {
	# 		Pop-Location
	# 	}

	# 	$result.displayPath | Should -Be ".\dir\file0"
	# }
}
