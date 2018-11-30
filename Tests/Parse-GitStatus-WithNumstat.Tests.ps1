. $PSScriptRoot\..\git-numbered.ps1

Describe 'Parse-GitStatus - with Numstat' {
	It 'Adds git diff --numstat to the output' {
		Mock Invoke-Git {
			if (([string]$args).StartsWith("status")) {
				" M file0"
			} else {
				# git diff --numstat
				"`t5`t3`tfile0"
			}
		}

		$result = Parse-GitStatus $true

		$result.Length | Should -Be 1
		$result.file | Should -Be file0
		$result.added | Should -Be 5
		$result.deleted | Should -Be 3
	}

	It 'numstat works for binary files' {
		Mock Invoke-Git {
			if (([string]$args).StartsWith("status")) {
				" M file0"
			} else {
				# git diff --numstat
				"`t-`t-`tfile0"
			}
		}

		$result = Parse-GitStatus $true

		$result.Length | Should -Be 1
		$result.file | Should -Be file0
		$result.added | Should -Be "-"
		$result.deleted | Should -Be "-"
	}

	It 'ignores warnings' {
		Mock Invoke-Git {
			if (([string]$args).StartsWith("status")) {
				" M file0"
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
