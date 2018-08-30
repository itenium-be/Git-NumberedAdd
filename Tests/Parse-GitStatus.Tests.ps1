. $PSScriptRoot\..\git-numbered.ps1


Describe 'Parse-GitStatus' {
	It 'Parses a single modified file in working directory' {
		Mock Invoke-Git { " M file0" }
		$result = Parse-GitStatus
		$result.Length | Should -Be 1
		$result.file | Should -Be file0
		$result.staged | Should -Be $false
		$result.state | Should -Be M
	}

	It 'Parses a single new file in working directory' {
		Mock Invoke-Git { "?? file0" }
		$result = Parse-GitStatus
		$result.Length | Should -Be 1
		$result.file | Should -Be file0
		$result.staged | Should -Be $false
		$result.state | Should -Be A
	}

	It 'Parses a single modified file in staging area' {
		Mock Invoke-Git { "M  file0" }
		$result = Parse-GitStatus
		$result.Length | Should -Be 1
		$result.file | Should -Be file0
		$result.staged | Should -Be $true
		$result.state | Should -Be M
	}

	It 'Parses a single new file in staging area' {
		Mock Invoke-Git { "A  file0" }
		$result = Parse-GitStatus
		$result.Length | Should -Be 1
		$result.file | Should -Be file0
		$result.staged | Should -Be $true
		$result.state | Should -Be A
	}

	It 'Parses a single modified file in staging area AND working directory' {
		Mock Invoke-Git { "MM file0" }
		$result = Parse-GitStatus

		$result.Length | Should -Be 2

		$result[0].file | Should -Be file0
		$result[0].staged | Should -Be $true
		$result[0].state | Should -Be M

		$result[1].file | Should -Be file0
		$result[1].staged | Should -Be $false
		$result[1].state | Should -Be M
	}

	It 'Parses multiple files' {
		Mock Invoke-Git { "M  file0"," D file1" }
		$result = Parse-GitStatus

		$result.Length | Should -Be 2

		$result[0].file | Should -Be file0
		$result[0].staged | Should -Be $true
		$result[0].state | Should -Be M

		$result[1].file | Should -Be file1
		$result[1].staged | Should -Be $false
		$result[1].state | Should -Be D
	}
}
