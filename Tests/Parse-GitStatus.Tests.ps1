. $PSScriptRoot\..\git-numbered.ps1


Describe 'Parse-GitStatus' {
	$file0 = "TestDrive:\file0"
	$file1 = "TestDrive:\file1"
	$file2 = "TestDrive:\spacey file2"

	New-Item $file0
	New-Item $file1
	New-Item $file2

	# Setup/Cleanup crashed...
	# BeforeEach {
	# 	Push-Location "TestDrive:"
	# 	New-Item $file0
	# 	New-Item $file1
	# }

	# AfterEach {
	# 	Remove-Item $file0
	# 	Remove-Item $file1
	# 	Pop-Location
	# }

	It 'Can parse a modified file rename' {
		Mock Invoke-Git { "RM $file0 -> $file2" }
		$result = Parse-GitStatus

		$result.Length | Should -Be 2
		$result[0].file | Should -Be "`"$file2`""
		$result[0].state | Should -Be "R"
		$result[0].oldFile | Should -Be $file0
		$result[0].staged | Should -Be $true

		$result[1].file | Should -Be "`"$file2`""
		$result[1].state | Should -Be "M"
		$result[1].oldFile | Should -Be $null
		$result[1].staged | Should -Be $false
	}

	It 'Add quotes around filename with spaces if it is not yet the case' {
		Mock Invoke-Git { "?? $file2" }
		$result = Parse-GitStatus

		$result.relativePath | Should -Be "`"$file2`""
		$result.file | Should -Be "`"$file2`""

		$fullPath = "`"$(Get-Location)\$file2`""
		$result.fullPath | Should -Be $fullPath
	}


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
		$result.file | Should -Be $file0
		$result.staged | Should -Be $false
		$result.state | Should -Be M
	}

	It 'Parses a single new file in working directory' {
		Mock Invoke-Git { "?? $file0" }
		$result = Parse-GitStatus
		$result.Length | Should -Be 1
		$result.file | Should -Be $file0
		$result.staged | Should -Be $false
		$result.state | Should -Be A
	}

	It 'Parses a single modified file in staging area' {
		Mock Invoke-Git { "M  $file0" }
		$result = Parse-GitStatus
		$result.Length | Should -Be 1
		$result.file | Should -Be $file0
		$result.staged | Should -Be $true
		$result.state | Should -Be M
	}

	It 'Parses a single new file in staging area' {
		Mock Invoke-Git { "A  $file0" }
		$result = Parse-GitStatus
		$result.Length | Should -Be 1
		$result.file | Should -Be $file0
		$result.staged | Should -Be $true
		$result.state | Should -Be A
	}

	It 'Parses a single modified file in staging area AND working directory' {
		Mock Invoke-Git { "MM $file0" }
		$result = Parse-GitStatus

		$result.Length | Should -Be 2

		$result[0].file | Should -Be $file0
		$result[0].staged | Should -Be $true
		$result[0].state | Should -Be M

		$result[1].file | Should -Be $file0
		$result[1].staged | Should -Be $false
		$result[1].state | Should -Be M
	}

	It 'Parses multiple files' {
		Mock Invoke-Git { "M  $file0"," D $file1" }
		$result = Parse-GitStatus

		$result.Length | Should -Be 2

		$result[0].file | Should -Be $file0
		$result[0].staged | Should -Be $true
		$result[0].state | Should -Be M

		$result[1].file | Should -Be $file1
		$result[1].staged | Should -Be $false
		$result[1].state | Should -Be D
	}
}
