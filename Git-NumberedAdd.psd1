@{
RootModule = 'Git-NumberedAdd.psm1'
ModuleVersion = '1.2'
GUID = '798d08b3-ae22-4e49-a8cb-b995654e87e9'
Author = 'Wouter Van Schandevijl'
CompanyName = 'itenium'
Copyright = '(c) itenium. All rights reserved.'
Description = 'Git add, diff, reset etc files with fabricated indexes'
PowerShellVersion = '2.0'

FunctionsToExport = @(
    "Git-NumberedHelp",
    "Git-NumberedStatus",
    "Git-NumberedAdd",
    "Git-NumberedAddPatch",
    "Git-NumberedDiff",
    "Git-NumberedDiffCached",
    "Git-NumberedReset",
    "Git-NumberedCheckout",
    "Git-GetFileNameByIndex",
    "Git-NumberedSetLocation",
    "Git-NumberedAssumed",
    "Git-ListAssumed",
    "Git-NumberedUnassumed",
    "Git-NumberedHidden",
    "Git-ListHidden",
    "Git-NumberedUnhidden"
)

CmdletsToExport = @()
VariablesToExport = '*'

AliasesToExport = @(
    "gnh", "gs", "ga", "gap", "gd", "gdc", "grs", "gco",
    "gn", "gsl", "gas", "gasl", "gnoas", "ghide", "glh",
    "gunhide"
)

FileList = @(
    "lib/core/Invoke-Git.ps1",
    "lib/utility/Git-GetFileNameByIndex.ps1",
    "lib/utility/Git-NumberedAssumed.ps1",
    "lib/utility/Git-NumberedSetLocation.ps1",
    "lib/Git-NumberedStatus.ps1",
    "lib/Parse-GitIndexes.ps1",
    "lib/Parse-GitStatus.ps1",
    "lib/actions/Git-NumberedAdd.ps1",
    "lib/actions/Git-NumberedCheckout.ps1",
    "lib/actions/Git-NumberedDiff.ps1",
    "lib/actions/Git-NumberedReset.ps1"
)

PrivateData = @{
    PSData = @{
        Tags = @("git")
        LicenseUri = 'https://github.com/itenium-be/Git-NumberedAdd/blob/master/LICENSE'
        ProjectUri = 'https://github.com/itenium-be/Git-NumberedAdd'
        # IconUri = ''
        ReleaseNotes = 'https://github.com/itenium-be/Git-NumberedAdd/releases/tag/v1.2'
    }
}

HelpInfoURI = 'https://itenium.be/blog/dev-setup/git-numbered-add-for-powershell/'
}
