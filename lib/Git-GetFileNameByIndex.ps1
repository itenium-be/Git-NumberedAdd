function Git-GetFileNameByIndex($index) {
	return $global:gitStatusNumbers.workingDir[$index].file
}
