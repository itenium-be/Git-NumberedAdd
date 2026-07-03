. $PSScriptRoot\TestBed.ps1

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

	Context 'with 18 files (more than 10)' {
		BeforeEach {
			$global:gitStatusNumbers.stagingArea = @()
			$global:gitStatusNumbers.workingDir = 0..17 | % { @{state="M";file="file$_";staged=$false} }
		}

		It 'Splits a leading-zero token even when the number is a valid index (017 == 0, 1, 7)' {
			$fileInfos = Parse-GitIndexes @("017")
			$fileInfos.Length | Should -Be 3
			$fileInfos[0].file | Should -Be 'file0'
			$fileInfos[1].file | Should -Be 'file1'
			$fileInfos[2].file | Should -Be 'file7'
		}

		It 'Keeps an in-range two-digit token without leading zero as a single index (15 == index 15)' {
			$fileInfos = Parse-GitIndexes @("15")
			$fileInfos.Length | Should -Be 1
			$fileInfos.file | Should -Be 'file15'
		}

		It 'Splits an out-of-range two-digit token into single digits (19 == 1, 9)' {
			$fileInfos = Parse-GitIndexes @("19")
			$fileInfos.Length | Should -Be 2
			$fileInfos[0].file | Should -Be 'file1'
			$fileInfos[1].file | Should -Be 'file9'
		}
	}
}
