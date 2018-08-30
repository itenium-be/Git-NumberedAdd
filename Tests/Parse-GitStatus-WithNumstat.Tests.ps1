. $PSScriptRoot\..\git-numbered.ps1

Describe 'Parse-GitStatus - with Numstat' {
	It 'Adds git diff --numstat to the output' {
		Mock Invoke-Git {
			if ([string]$args -eq "status -s") {
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
}
