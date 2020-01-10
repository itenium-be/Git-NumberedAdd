. $PSScriptRoot\..\git-numbered.ps1

$global:gitStatusNumbers.stagingArea = @(
	@{state="M";file="staged0";staged=$true},
	@{state="M";file="staged1";staged=$true},
	@{state="M";file="staged2";staged=$true}
)

$global:gitStatusNumbers.workingDir = @(
	@{state="M";file="file0";staged=$false},
	@{state="M";file="file1";staged=$false},
	@{state="M";file="file2";staged=$false},
	@{state="M";file="file3";staged=$false},
	@{state="M";file="file4";staged=$false},
	@{state="M";file="file5";staged=$false},
	@{state="M";file="file6";staged=$false}
)


Describe 'Parse-GitIndexes' {
	BeforeEach {
		Push-Location "TestDrive:"
	}

	AfterEach {
		Pop-Location
	}

	It 'Parses a single int argument' {
		$fileInfos = Parse-GitIndexes @(3)
		$fileInfos.Length | Should -Be 1
		$fileInfos.file | Should -Be 'file3'
	}

	It 'Parses a single string argument' {
		$fileInfos = Parse-GitIndexes @("3")
		$fileInfos.Length | Should -Be 1
		$fileInfos.file | Should -Be 'file3'
	}

	It 'Parses 0 string argument' {
		$fileInfos = Parse-GitIndexes @("0")
		$fileInfos.Length | Should -Be 1
		$fileInfos.file | Should -Be 'file0'
	}

	It 'Parses 0 int argument' {
		$fileInfos = Parse-GitIndexes @(0)
		$fileInfos.Length | Should -Be 1
		$fileInfos.file | Should -Be 'file0'
	}

	It 'Parses range argument 0-2' {
		$fileInfos = Parse-GitIndexes @("0-2")
		$fileInfos.Length | Should -Be 3
		$fileInfos[0].file | Should -Be 'file0'
		$fileInfos[1].file | Should -Be 'file1'
		$fileInfos[2].file | Should -Be 'file2'
	}

	It 'Parses -x argument' {
		$fileInfos = Parse-GitIndexes @("-2")
		$fileInfos.Length | Should -Be 2
		$fileInfos[0].file | Should -Be 'file0'
		$fileInfos[1].file | Should -Be 'file1'
	}

	It 'Parses +x argument' {
		$fileInfos = Parse-GitIndexes @("+4")
		$fileInfos.Length | Should -Be 2
		$fileInfos[0].file | Should -Be 'file5'
		$fileInfos[1].file | Should -Be 'file6'
	}

	It 'Parses multiple arguments' {
		$fileInfos = Parse-GitIndexes "0-1",5
		$fileInfos.Length | Should -Be 3
		$fileInfos[0].file | Should -Be 'file0'
		$fileInfos[1].file | Should -Be 'file1'
		$fileInfos[2].file | Should -Be 'file5'
	}

	It 'Parses multiple indexes in 1 int argument' {
		$fileInfos = Parse-GitIndexes 12
		$fileInfos.Length | Should -Be 2
		$fileInfos[0].file | Should -Be 'file1'
		$fileInfos[1].file | Should -Be 'file2'
	}

	It 'Parses multiple indexes in 1 string argument' {
		$fileInfos = Parse-GitIndexes "12"
		$fileInfos.Length | Should -Be 2
		$fileInfos[0].file | Should -Be 'file1'
		$fileInfos[1].file | Should -Be 'file2'
	}

	It 'Parses multiple indexes in 1 argument with leading zero' {
		$fileInfos = Parse-GitIndexes "01"
		$fileInfos.Length | Should -Be 2
		$fileInfos[0].file | Should -Be 'file0'
		$fileInfos[1].file | Should -Be 'file1'
	}
}




Describe 'Parse-GitIndexes for stagingArea (Git-NumberedReset)' {
	It 'Gets the fileInfo from the stagingArea array' {
		$fileInfos = Parse-GitIndexes 1 "stagingArea"
		$fileInfos.Length | Should -Be 1
		$fileInfos.file | Should -Be 'staged1'
	}

	It "Can't return fileInfo that is outside the boundaries" {
		Mock Write-Host { }
		$fileInfos = Parse-GitIndexes 5 "stagingArea"
		$fileInfos.Length | Should -Be 0
		Assert-MockCalled Write-Host -Times 1
	}
}
