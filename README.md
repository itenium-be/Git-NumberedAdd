# Git-NumberedAdd

PowerShell script to git add, diff, reset, etc files with fabricated indexes.

See [the itenium blog for a more detailed explanation](https://itenium.be/blog/productivity/git-numbered-add-for-powershell).


## Running Tests

```powershell
Install-Module -Name Pester -Force -SkipPublisherCheck
Install-Module PestWatch

# Run all & watch
Invoke-PesterWatcher

# Run a single "Describe" test suite
Invoke-Pester -TestName "Parse-GitStatus"

# Run matching files
Invoke-Pester ./tests/Parse-GitStatus*

# Run CI
Invoke-Pester -PassThru
```

Use `Write-Host` to log something inside a test.

[wiki/Should](https://github.com/pester/Pester/wiki/Should)



## Available actions

```powershell
# Display all actions with description and alias
Git-NumberedHelp # alias: gnh

# Start with
Git-NumberedStatus # Alias: gs
# to see the git status -s with added indexes
# Use `gs -u` to see all added files in new directories

# And continue with
Git-NumberedAdd # Alias: ga
Git-NumberedAddPatch # Alias: gap
Git-NumberedDiff # Alias: gd
Git-NumberedDiffCached # Alias: gdc
Git-NumberedCheckout # Alias: gco


# Already staged files can be
# git reset HEAD with
Git-NumberedReset # Alias: grs


# Get a filename by index
Git-GetFileNameByIndex 5 # Alias: gn
# Deleting a file by index
rm (gn 2)


# Push-Location
Git-NumberedSetLocation # Alias: gsl
# Use Pop-Location (alias: popd) to go back to where you came from


# git update-index --assume-unchanged
Git-NumberedAssumed # alias: gas
```

### Accepted argument values for matching indexes

```powershell
# Stage files 0, 1 and 3
Git-NumberedAdd 0 1 3

# The spaces are optional, but only when there
# are less than 10 files in the status report.
Git-NumberedDiff 013

# Checkout files 2 to 5 (all inclusive)
Git-NumberedCheckout 2-5

# Display diff for files 0, 1 and 2
Git-NumberedDiff -3

# Stage all files after (not inclusive)
Git-NumberedAdd +3

# Combine as you like
Git-NumberedAdd -3 5 6 8-9
```



### Git-Assuming

Unassume files back again after `Git-NumberedAssumed` (alias: gas)

```powershell
# List all currently assumed files
Git-ListAssumed # alias: gasl

# and follow with:
# git update-index --no-assume-unchanged
Git-NumberedUnassumed # alias: gnoas
```

#### Git-SkipWorktree

Also for `--skip-worktree` with `Git-NumberedHidden` (alias: ghide)

```powershell
# List all currently hidden files
Git-ListHidden # alias: glh

# git update-index --no-skip-worktree
Git-NumberedUnhidden # alias: gunhide
```
