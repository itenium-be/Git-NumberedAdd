$global:gitStatusNumbers = @{
	# @{state=A/M/D/R;file=$gitRootPath;staged=$true/$false;fullPath='';relativePath=''}
	# state: A(dded) / M(odified) / D(eleted) / R(enamed)
	stagingArea=$null;
	workingDir=$null;

	stagedColor='Green';
	addedColor='Blue';
	modifiedColor='Yellow';
	deletedColor='DarkMagenta';
	renamedColor='Yellow';

	includeNumstat=$true;
	displayFilesAs='relative-path'; # full-path | relative-path | gitroot-path
}

# $global:gitStatusNumbers.displayFilesAs="full-path"
# $global:gitStatusNumbers.displayFilesAs="gitroot-path"


# Use Utf8 when capturing git output
[Console]::OutputEncoding = [System.Text.Encoding]::Utf8



Get-ChildItem -Recurse ("$PSScriptRoot\lib\*.ps1") | ForEach-Object {. $_.FullName}

# If you get stuck, get help!
Set-Alias gnh Git-NumberedHelp

# Start with:
Set-Alias gs Git-NumberedStatus

# Actions
Set-Alias ga Git-NumberedAdd
Set-Alias gap Git-NumberedAddPatch
Set-Alias gd Git-NumberedDiff
Set-Alias gdc Git-NumberedDiffCached
Set-Alias grs Git-NumberedReset
Set-Alias gco Git-NumberedCheckout

# Utility
Set-Alias gn Git-GetFileNameByIndex
Set-Alias gsl Git-NumberedSetLocation

## Assuming
Set-Alias gas Git-NumberedAssumed
Set-Alias gasl Git-ListAssumed
Set-Alias gnoas Git-NumberedUnassumed

Set-Alias ghide Git-NumberedHidden
Set-Alias glh Git-ListHidden
Set-Alias gunhide Git-NumberedUnhidden


##############################################################################
#.SYNOPSIS
# Displays help for all Git-Numbered actions and utilities
##############################################################################
function Git-NumberedHelp() {
	$table = Get-Command -Name "Git-*" | ? { $_.CommandType -eq 'Function' } | % {
		$name = $_.name
		$help = get-help $_ -Full
		$example = If ($help.Examples) {$true} Else {''}
		$alias = Get-Alias -Definition $name -ErrorAction SilentlyContinue

		return @{Name=$name;Description=$help.Synopsis;Examples=$example;Alias=$alias}
	}

	$table.ForEach({[PSCustomObject]$_}) | Format-Table Alias, Name, Description, Examples -AutoSize

	Write-Host "Configuration`n==============" -ForegroundColor Yellow
	Write-Host "To update: `$global:gitStatusNumbers.stagedColor = 'Red'"
	$options = @(
		[PSCustomObject]@{ Setting = 'stagedColor'; Value = $global:gitStatusNumbers.stagedColor; Description = "" }
		[PSCustomObject]@{ Setting = 'addedColor'; Value = $global:gitStatusNumbers.addedColor }
		[PSCustomObject]@{ Setting = 'modifiedColor'; Value = $global:gitStatusNumbers.modifiedColor }
		[PSCustomObject]@{ Setting = 'deletedColor'; Value = $global:gitStatusNumbers.deletedColor }
		[PSCustomObject]@{ Setting = 'renamedColor'; Value = $global:gitStatusNumbers.renamedColor }
		[PSCustomObject]@{ Setting = 'includeNumstat'; Value = $global:gitStatusNumbers.includeNumstat; Description = "Show added/deleted line counts" }
		[PSCustomObject]@{ Setting = 'displayFilesAs'; Value = $global:gitStatusNumbers.displayFilesAs; Description = "One of: full-path | relative-path | gitroot-path" }
	)
	$options | Format-Table Setting, Value, Description -AutoSize

	Write-Host "Tutorial: https://itenium.be/blog/productivity/git-numbered-add-for-powershell"
}
