$repoPath = "Playground"
New-Item -ItemType Directory -Path $repoPath | Out-Null
Push-Location $repoPath

git init | Out-Null

@(
	@{ Name = "README.md"; Content = "# Demo Repository`nThis is a demo repo created by PowerShell." },
	@{ Name = "app.txt"; Content = "Version 1.0`nHello World" },
	@{ Name = "config.json"; Content = '{ "version": "1.0", "enabled": true }' },
	@{ Name = ".gitignore"; Content = 'node_modules' },
	@{ Name = "HOW TO.md"; Content = 'HOW TO`n======' }
	@{ Name = "RELEASE NOTES.md"; Content = 'RELEASE NOTES`n======' }
) | ForEach-Object {
	Set-Content -Path $_.Name -Value $_.Content
}

git add .
git commit -m "Initial commit with demo files"

Add-Content -Path "app.txt" -Value "`nFeature added at $(Get-Date)"
(Get-Content "config.json") -replace '"enabled": true', '"enabled": false' | Set-Content "config.json"
Add-Content -Path "HOW TO.md" -Value "`nJust do it"
Add-Content -Path "RELEASE NOTES.md" -Value "`nLots of bugfixes"
Set-Content -Path "DEV SETUP.md" -Value "How to get this thing running"

git add app.txt

Pop-Location

echo "Check out the mega dummy repository:"
echo "cd Playground"
