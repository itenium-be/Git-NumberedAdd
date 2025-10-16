. $PSScriptRoot\TestBed.ps1


Describe 'Parse-GitStatus' {
	BeforeAll {
		New-Item "TestDrive:\file0"
		New-Item "TestDrive:\file1"
		New-Item "TestDrive:\spacey file2"
	}

	It 'Can parse a modified file rename' {
		Mock Invoke-Git { "RM TestDrive:\file0 -> TestDrive:\spacey file2" }
		$result = Parse-GitStatus

		$result.Length | Should -Be 2
		$result[0].file | Should -Be "`"TestDrive:\spacey file2`""
		$result[0].state | Should -Be "R"
		$result[0].oldFile | Should -Be "TestDrive:\file0"
		$result[0].staged | Should -Be $true

		$result[1].file | Should -Be "`"TestDrive:\spacey file2`""
		$result[1].state | Should -Be "M"
		$result[1].oldFile | Should -Be $null
		$result[1].staged | Should -Be $false
	}

	It 'Add quotes around filename with spaces if it is not yet the case' {
		Mock Invoke-Git { "?? TestDrive:\spacey file2" }
		$result = Parse-GitStatus

		$result.relativePath | Should -Be "`"TestDrive:\spacey file2`""
		$result.file | Should -Be "`"TestDrive:\spacey file2`""

		$fullPath = "`"$(Get-Location)\TestDrive:\spacey file2`""
		$result.fullPath | Should -Be $fullPath
	}


	It 'Passes extra CLI arguments along to git status' {
		Mock Invoke-Git {
			[string]$args | Should -BeLike "* -u"
			" M TestDrive:\file0"
		}

		$result = Parse-GitStatus $false "-u"
	}

	It 'Parses a single modified file in working directory' {
		Mock Invoke-Git { " M TestDrive:\file0" }
		$result = Parse-GitStatus
		$result.Length | Should -Be 1
		$result.file | Should -Be "TestDrive:\file0"
		$result.staged | Should -Be $false
		$result.state | Should -Be M
	}

	It 'Parses a single new file in working directory' {
		Mock Invoke-Git { "?? TestDrive:\file0" }
		$result = Parse-GitStatus
		$result.Length | Should -Be 1
		$result.file | Should -Be "TestDrive:\file0"
		$result.staged | Should -Be $false
		$result.state | Should -Be A
	}

	It 'Parses a single modified file in staging area' {
		Mock Invoke-Git { "M  TestDrive:\file0" }
		$result = Parse-GitStatus
		$result.Length | Should -Be 1
		$result.file | Should -Be "TestDrive:\file0"
		$result.staged | Should -Be $true
		$result.state | Should -Be M
	}

	It 'Parses a single new file in staging area' {
		Mock Invoke-Git { "A  TestDrive:\file0" }
		$result = Parse-GitStatus
		$result.Length | Should -Be 1
		$result.file | Should -Be "TestDrive:\file0"
		$result.staged | Should -Be $true
		$result.state | Should -Be A
	}

	It 'Parses a single modified file in staging area AND working directory' {
		Mock Invoke-Git { "MM TestDrive:\file0" }
		$result = Parse-GitStatus

		$result.Length | Should -Be 2

		$result[0].file | Should -Be "TestDrive:\file0"
		$result[0].staged | Should -Be $true
		$result[0].state | Should -Be M

		$result[1].file | Should -Be "TestDrive:\file0"
		$result[1].staged | Should -Be $false
		$result[1].state | Should -Be M
	}

	It 'Parses multiple files' {
		Mock Invoke-Git { "M  TestDrive:\file0"," D TestDrive:\file1" }
		$result = Parse-GitStatus

		$result.Length | Should -Be 2

		$result[0].file | Should -Be "TestDrive:\file0"
		$result[0].staged | Should -Be $true
		$result[0].state | Should -Be M

		$result[1].file | Should -Be "TestDrive:\file1"
		$result[1].staged | Should -Be $false
		$result[1].state | Should -Be D
	}
}
