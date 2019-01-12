##############################################################################
#.SYNOPSIS
# Gets the full path of ths single index passed as $args
##############################################################################
function Git-GetFileNameByIndex($index) {
	return $global:gitStatusNumbers.workingDir[$index].fullPath
}
