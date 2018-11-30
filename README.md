# Git-NumberedAdd

PowerShell script to git add, diff and reset files with fabricated indexes.

See [the itenium blog for a more detailed explanation](https://itenium.be/blog/productivity/git-numbered-add-for-powershell).


Available functions:  
```powershell
# Start with
Git-NumberedStatus # Alias: gs
# to see the git status -s with added indexes
# Use `gs -u` to see all added files in new directories

# And continue with
Git-NumberedAdd # Alias: ga
Git-NumberedDiff # Alias: gd

# Already staged files can be
# git reset HEAD with
Git-NumberedReset # Alias: grs

# Get a filename by index
Git-GetFileNameByIndex 5 # Alias: gn
# Deleting a file by index
rm (gn 2)
```

Accepted argument values:  
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

## Running Tests

```powershell
Install-Module -Name Pester -Force -SkipPublisherCheck
Install-Module PestWatch

Invoke-PesterWatcher
```


## The Future

Some things that could still be implemented:

- Git-NumberedCheckout
- Git-NumberedChangeLocation (ie cd into dir)
- Git-NumberedDiff: Should also work for already staged files
- Git-NumberedAdd & Reset: Should be possible to first Add and then Reset a file by using the same index?
- Could also be implemented for `git assumed` and `git log` etc.
- Git-NumberedAdd should allow args like --word-diff?
