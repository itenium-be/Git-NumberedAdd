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
# [Console]::OutputEncoding = [System.Text.Encoding]::Utf8

BeforeAll {
	Get-ChildItem -Recurse ("$PSScriptRoot\..\Git-NumberedAdd\lib\*.ps1") | ForEach-Object {. $_.FullName}
}
