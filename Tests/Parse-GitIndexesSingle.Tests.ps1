. $PSScriptRoot\..\git-numbered.ps1

# Parse-GitIndexes tests with different workingDir/stagingArea
# See Parse-GitIndexes.Tests.ps1 for common use cases with the same workingDir/stagingArea

Describe 'Parse-GitIndexes - tests with specific stagingArea/workingDir' {
	BeforeEach {
		Push-Location "TestDrive:"
	}

	AfterEach {
		Pop-Location
	}

	It 'Parses the single zero indexed file' {
		$global:gitStatusNumbers.stagingArea = @()

		$global:gitStatusNumbers.workingDir = @(
			@{state="M";file="file0";staged=$true}
		)

		$fileInfos = Parse-GitIndexes @(0)
		$fileInfos.Length | Should -Be 1
		$fileInfos.file | Should -Be 'file0'
	}

	It 'Parses 0123456789 when there are 10 elements' {
		$global:gitStatusNumbers.stagingArea = @()
		$global:gitStatusNumbers.workingDir = @(
			@{state="M";file="file0";staged=$false},
			@{state="M";file="file1";staged=$false},
			@{state="M";file="file2";staged=$false},
			@{state="M";file="file3";staged=$false},
			@{state="M";file="file4";staged=$false},
			@{state="M";file="file5";staged=$false},
			@{state="M";file="file6";staged=$false},
			@{state="M";file="file7";staged=$false},
			@{state="M";file="file8";staged=$false},
			@{state="M";file="file9";staged=$false}
		)

		$fileInfos = Parse-GitIndexes @("0123456789")
		$fileInfos.Length | Should -Be 10
	}

	It 'Parses 01234 when there are less than 1234 elements' {
		$global:gitStatusNumbers.stagingArea = @()
		$global:gitStatusNumbers.workingDir = @(
			@{state="M";file="file0";staged=$false},
			@{state="M";file="file1";staged=$false},
			@{state="M";file="file2";staged=$false},
			@{state="M";file="file3";staged=$false},
			@{state="M";file="file4";staged=$false},
			@{state="M";file="file5";staged=$false},
			@{state="M";file="file6";staged=$false},
			@{state="M";file="file7";staged=$false},
			@{state="M";file="file8";staged=$false},
			@{state="M";file="file9";staged=$false},
			@{state="M";file="file10";staged=$false},
			@{state="M";file="file11";staged=$false}
		)

		$fileInfos = Parse-GitIndexes @("01234")
		$fileInfos.Length | Should -Be 5
	}

	It 'Parses 012 when there are less than 13 elements' {
		$global:gitStatusNumbers.stagingArea = @()
		$global:gitStatusNumbers.workingDir = @(
			@{state="M";file="file0";staged=$false},
			@{state="M";file="file1";staged=$false},
			@{state="M";file="file2";staged=$false},
			@{state="M";file="file3";staged=$false},
			@{state="M";file="file4";staged=$false},
			@{state="M";file="file5";staged=$false},
			@{state="M";file="file6";staged=$false},
			@{state="M";file="file7";staged=$false},
			@{state="M";file="file8";staged=$false},
			@{state="M";file="file9";staged=$false},
			@{state="M";file="file10";staged=$false},
			@{state="M";file="file11";staged=$false}
		)

		$fileInfos = Parse-GitIndexes @("012")
		$fileInfos.Length | Should -Be 3
	}
}
