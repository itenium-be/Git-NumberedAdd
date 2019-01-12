# Git-NumberedAdd

PowerShell script to git add, diff and reset files with fabricated indexes.

See [the itenium blog for a more detailed explanation](https://itenium.be/blog/productivity/git-numbered-add-for-powershell).


**Available functions**:  
```powershell
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

**Accepted argument values**:  
```powershell
# Stage files 0, 1 and 3
Git-NumberedAdd 0 1 3

# The spaces are optional, but only when there
# are less than 10 files in the status report.
Git-NumberedAdd 013

# Stage files 2 to 5 (all inclusive)
Git-NumberedAdd 2-5

# Stage files 0, 1 and 2
Git-NumberedAdd -3

# Stage all files after (not inclusive)
Git-NumberedAdd +3

# Combine as you like
Git-NumberedAdd -3 5 6 8-9
```



## Git-Assuming

Unassume files back again after `Git-NumberedAssumed` (alias: gas)

```powershell
# List all currently assumed files
Git-ListAssumed # alias: gasl

# and follow with:
# git update-index --no-assume-unchanged
Git-NumberedUnassumed # alias: gnoas
```



## Running Tests

```powershell
Install-Module -Name Pester -Force -SkipPublisherCheck
Install-Module PestWatch

Invoke-PesterWatcher
```

Use `Write-Host` to log something inside a test.

[wiki/Should](https://github.com/pester/Pester/wiki/Should)




- Should take the current path (if not git repo root) into account

