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
	@{state="M";file="file6";staged=$false},
	@{state="M";file="file7";staged=$false},
	@{state="M";file="file8";staged=$false},
	@{state="M";file="file9";staged=$false}
)


Describe 'Parse-GitIndexes edge cases' {
	It 'Parses 0123456789 when there are 10 elements' {
		$fileInfos = Parse-GitIndexes @("0123456789")
		$fileInfos.Length | Should -Be 10
	}
}
