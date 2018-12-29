$global:gitStatusNumbers = @{
	stagingArea=$null;
	workingDir=$null;

	stagedColor='Green';
	addedColor='Blue';
	modifiedColor='Yellow';
	deletedColor='DarkMagenta';
	renamedColor='Yellow';

	includeNumstat=$true;
}


Get-ChildItem ("$PSScriptRoot\lib\*.ps1") | ForEach-Object {. $_.FullName}


Set-Alias gs Git-NumberedStatus
Set-Alias ga Git-NumberedAdd
Set-Alias gd Git-NumberedDiff
Set-Alias grs Git-NumberedReset
Set-Alias gn Git-GetFileNameByIndex
