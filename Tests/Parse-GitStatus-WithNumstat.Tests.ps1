. $PSScriptRoot\..\git-numbered.ps1

$file0 = "TestDrive:\file0"
$file1 = "TestDrive:\file1"

Describe 'Parse-GitStatus - with Numstat' {
	New-Item $file0
	New-Item $file1

	$global:gitStatusNumbers.displayFilesAs = 'relative-gitroot'

	# BeforeEach {
	# 	Push-Location "TestDrive:"
	# }

	# AfterEach {
	# 	Pop-Location
	# }

	It 'Adds git diff --numstat to the output' {
		Mock Invoke-Git {
			if (([string]$args).StartsWith("status")) {
				" M $file0"
			} else {
				# git diff --numstat
				"`t5`t3`t$file0"
			}
		}

		$result = Parse-GitStatus $true

		$result.Length | Should -Be 1
		$result.displayPath | Should -Be $file0
		$result.added | Should -Be 5
		$result.deleted | Should -Be 3
	}

	It 'numstat works for binary files' {
		Mock Invoke-Git {
			if (([string]$args).StartsWith("status")) {
				" M $file0"
			} else {
				# git diff --numstat
				"`t-`t-`t$file0"
			}
		}

		$result = Parse-GitStatus $true

		$result.Length | Should -Be 1
		$result.displayPath | Should -Be $file0
		$result.added | Should -Be "-"
		$result.deleted | Should -Be "-"
	}

	It 'ignores LF/CRLF warnings' {
		Mock Invoke-Git {
			if (([string]$args).StartsWith("status")) {
				" M $file0"
			} else {
				# git diff --numstat
				" warning: LF will be replaced by CRLF in ..."
			}
		}

		$result = Parse-GitStatus $true

		# No crash = good
		$result.Length | Should -Be 1
	}
}
