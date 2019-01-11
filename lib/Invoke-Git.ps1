function Invoke-Git {
	# Exists solely for mocking purposes
	& git $args
}

function Push-GitRootLocation {
	Push-Location (git rev-parse --show-toplevel)
}

function Pop-GitRootLocation {
	Pop-Location
}
