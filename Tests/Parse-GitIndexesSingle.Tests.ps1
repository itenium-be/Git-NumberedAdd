. $PSScriptRoot\..\git-numbered.ps1

$global:gitStatusNumbers.stagingArea = @(
)

$global:gitStatusNumbers.workingDir = @(
	@{state="M";file="file0";staged=$true}
)

Describe 'Parse-GitIndexes (Single)' {
	It 'Parses the single zero indexed file' {
		$fileInfos = Parse-GitIndexes @(0)
		$fileInfos.Length | Should -Be 1
		$fileInfos.file | Should -Be 'file0'
	}
}
