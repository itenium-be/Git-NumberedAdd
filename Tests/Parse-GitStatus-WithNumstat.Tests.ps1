. $PSScriptRoot\TestBed.ps1

Describe 'Parse-GitStatus - with Numstat' {
	BeforeAll {
		New-Item -Path "TestDrive:\file0" -ItemType File
		New-Item -Path "TestDrive:\file1" -ItemType File
		New-Item -Path "TestDrive:\spacey file2" -ItemType File
	}

	It '--numstat works for quoted files' {
		Mock Invoke-Git {
			if (([string]$args).StartsWith("status")) {
				" M `"TestDrive:\spacey file2`""
			} else {
				# git diff --numstat
				"`t5`t3`tTestDrive:\spacey file2"
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
				" M TestDrive:\file0"
			} else {
				# git diff --numstat
				"`t5`t3`tTestDrive:\file0"
			}
		}

		$result = Parse-GitStatus $true

		$result.Length | Should -Be 1
		$result.file | Should -Be "TestDrive:\file0"
		$result.added | Should -Be 5
		$result.deleted | Should -Be 3
	}


	It 'numstat works for binary files' {
		Mock Invoke-Git {
			if (([string]$args).StartsWith("status")) {
				" M TestDrive:\file0"
			} else {
				# git diff --numstat
				"`t-`t-`tTestDrive:\file0"
			}
		}

		$result = Parse-GitStatus $true

		$result.Length | Should -Be 1
		$result.file | Should -Be "TestDrive:\file0"
		$result.added | Should -Be "-"
		$result.deleted | Should -Be "-"
	}


	It 'adds LF/CRLF warnings to the fileInfo' {
		# This test fails on the CI because of Write-Error resulting in a WriteErrorException
		# Adding -ErrorAction silentlycontinue already made it crash locally
		Mock Invoke-Git {
			if (([string]$args).StartsWith("status")) {
				" M TestDrive:\file0"
			} else {
				# git diff --numstat
				Write-Error "warning: LF will be replaced by CRLF in TestDrive:\file0."
				Write-Error "The file will have its original line endings in your working directory."

				# $Host.UI.WriteErrorLine("warning: LF will be replaced by CRLF in TestDrive:\file0.")
				# $Host.UI.WriteErrorLine("The file will have its original line endings in your working directory.")

				" `t5`t3`tTestDrive:\file0"
			}
		}

		$result = Parse-GitStatus $true

		$result.lineEndings | Should -Be 'LF -> CRLF'
	}

	It 'does not crash when there is some new, unexpected, warning' {
		# This test fails on the CI because of Write-Error resulting in a WriteErrorException
		# Adding -ErrorAction silentlycontinue already made it crash locally
		Mock Invoke-Git {
			if (([string]$args).StartsWith("status")) {
				" M TestDrive:\file0"
			} else {
				# git diff --numstat
				Write-Error "warning: this is completely unexpected"
				" `t5`t3`tTestDrive:\file0"
			}
		}

		$result = Parse-GitStatus $true

		$result.lineEndings | Should -Be $null
	}

	It 'adds LF/CRLF warnings to the fileInfo (updated error message for git 2.26+)' {
		# This test fails on the CI because of Write-Error resulting in a WriteErrorException
		# Adding -ErrorAction silentlycontinue already made it crash locally
		Mock Invoke-Git {
			if (([string]$args).StartsWith("status")) {
				" M TestDrive:\file0"
			} else {
				# git diff --numstat
				Write-Error "warning: in the working copy of 'TestDrive:\file0', LF will be replaced by CRLF the next time Git touches it"
				" `t5`t3`tTestDrive:\file0"
			}
		}

		$result = Parse-GitStatus $true

		$result.lineEndings | Should -Be 'LF -> CRLF'
	}
}
