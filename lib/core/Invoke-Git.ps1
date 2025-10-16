function Invoke-Git {
	# Exists solely for mocking purposes
	& git @args
}

function Get-GitRootLocation {
	git rev-parse --show-toplevel
}
