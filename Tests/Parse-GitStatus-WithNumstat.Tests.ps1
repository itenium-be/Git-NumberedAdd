. $PSScriptRoot\..\git-numbered.ps1

$file0 = "TestDrive:\file0"
$file1 = "TestDrive:\file1"
$file2 = "TestDrive:\spacey file2"

Describe 'Parse-GitStatus - with Numstat' {
	New-Item $file0
	New-Item $file1
	New-Item $file2

	# BeforeEach {
	# 	Push-Location "TestDrive:"
	# }

	# AfterEach {
	# 	Pop-Location
	# }

	It '--numstat works for quoted files' {
		Mock Invoke-Git {
			if (([string]$args).StartsWith("status")) {
				" M $file2"
			} else {
				# git diff --numstat
				"`t5`t3`t$file2"
			}
		}

		$result = Parse-GitStatus $true

		$result.Length | Should -Be 1
		$result.added | Should -Be 5
		$result.deleted | Should -Be 3
	}

	It 'Adds git diff --numstat to the output' {
		Mock Invoke-Git {
			if (([string]$args).StartsWith("status")) {
				" M $file0"
			} else {
				# git diff --numstat
				"`t5`t3`t$file0"
			}
		}

		$result = Parse-GitStatus $true

		$result.Length | Should -Be 1
		$result.file | Should -Be $file0
		$result.added | Should -Be 5
		$result.deleted | Should -Be 3
	}


	It 'numstat works for binary files' {
		Mock Invoke-Git {
			if (([string]$args).StartsWith("status")) {
				" M $file0"
			} else {
				# git diff --numstat
				"`t-`t-`t$file0"
			}
		}

		$result = Parse-GitStatus $true

		$result.Length | Should -Be 1
		$result.file | Should -Be $file0
		$result.added | Should -Be "-"
		$result.deleted | Should -Be "-"
	}


	It 'adds LF/CRLF warnings to the fileInfo' {
		Mock Invoke-Git {
			if (([string]$args).StartsWith("status")) {
				" M $file0"
			} else {
				# git diff --numstat
				Write-Error "warning: LF will be replaced by CRLF in $file0."
				Write-Error "The file will have its original line endings in your working directory."
				" `t5`t3`t$file0"
			}
		}

		$result = Parse-GitStatus $true

		$result.lineEndings | Should -Be 'LF -> CRLF'
	}
}
