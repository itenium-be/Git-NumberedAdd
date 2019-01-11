. $PSScriptRoot\..\git-numbered.ps1

$file0 = "TestDrive:\file0"
$file1 = "TestDrive:\file1"


Describe 'Parse-GitStatus' {
	New-Item $file0
	New-Item $file1

	$global:gitStatusNumbers.displayFilesAs = 'relative-gitroot'

	It 'Passes extra CLI arguments along to git status' {
		Mock Invoke-Git {
			[string]$args | Should -BeLike "* -u"
			" M $file0"
		}

		$result = Parse-GitStatus $false "-u"
	}

	It 'Parses a single modified file in working directory' {
		Mock Invoke-Git { " M $file0" }
		$result = Parse-GitStatus
		$result.Length | Should -Be 1
		$result.displayPath | Should -Be $file0
		$result.staged | Should -Be $false
		$result.state | Should -Be M
	}

	It 'Parses a single new file in working directory' {
		Mock Invoke-Git { "?? $file0" }
		$result = Parse-GitStatus
		$result.Length | Should -Be 1
		$result.displayPath | Should -Be $file0
		$result.staged | Should -Be $false
		$result.state | Should -Be A
	}

	It 'Parses a single modified file in staging area' {
		Mock Invoke-Git { "M  $file0" }
		$result = Parse-GitStatus
		$result.Length | Should -Be 1
		$result.displayPath | Should -Be $file0
		$result.staged | Should -Be $true
		$result.state | Should -Be M
	}

	It 'Parses a single new file in staging area' {
		Mock Invoke-Git { "A  $file0" }
		$result = Parse-GitStatus
		$result.Length | Should -Be 1
		$result.displayPath | Should -Be $file0
		$result.staged | Should -Be $true
		$result.state | Should -Be A
	}

	It 'Parses a single modified file in staging area AND working directory' {
		Mock Invoke-Git { "MM $file0" }
		$result = Parse-GitStatus

		$result.Length | Should -Be 2

		$result[0].displayPath | Should -Be $file0
		$result[0].staged | Should -Be $true
		$result[0].state | Should -Be M

		$result[1].displayPath | Should -Be $file0
		$result[1].staged | Should -Be $false
		$result[1].state | Should -Be M
	}

	It 'Parses multiple files' {
		Mock Invoke-Git { "M  $file0"," D $file1" }
		$result = Parse-GitStatus

		$result.Length | Should -Be 2

		$result[0].displayPath | Should -Be $file0
		$result[0].staged | Should -Be $true
		$result[0].state | Should -Be M

		$result[1].displayPath | Should -Be $file1
		$result[1].staged | Should -Be $false
		$result[1].state | Should -Be D
	}
}
