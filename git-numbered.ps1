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


Get-ChildItem -Recurse ("$PSScriptRoot\lib\*.ps1") | ForEach-Object {. $_.FullName}


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
Set-Alias gnoas Git-NumberedNoAssumed
