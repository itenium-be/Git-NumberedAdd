@{
# Script module or binary module file associated with this manifest.
# https://github.com/nightroman/PowerShellTraps/tree/master/Module/v2-Manifest-RootModule-is-not-supported
RootModule = 'Git-NumberedAdd.psm1'
# ModuleToProcess = 'Git-NumberedAdd.psm1'

# Version number of this module.
ModuleVersion = '1.1'

# Supported PSEditions
# CompatiblePSEditions = @()

# ID used to uniquely identify this module
GUID = '798d08b3-ae22-4e49-a8cb-b995654e87e9'

# Author of this module
Author = 'Wouter Van Schandevijl'

# Company or vendor of this module
CompanyName = 'itenium'

# Copyright statement for this module
Copyright = '(c) itenium. All rights reserved.'

# Description of the functionality provided by this module
Description = 'Git add, diff, reset etc files with fabricated indexes'

# Minimum version of the PowerShell engine required by this module
PowerShellVersion = '2.0'

# Name of the PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
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

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @(
    "gnh",
    "gs",
    "ga",
    "gap",
    "gd",
    "gdc",
    "grs",
    "gco",
    "gn",
    "gsl",
    "gas",
    "gasl",
    "gnoas",
    "ghide",
    "glh",
    "gunhide"
)

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
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

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{
    PSData = @{
        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @("git")
        LicenseUri = 'https://github.com/itenium-be/Git-NumberedAdd/blob/master/LICENSE'
        ProjectUri = 'https://github.com/itenium-be/Git-NumberedAdd'
        # IconUri = ''
        ReleaseNotes = 'https://github.com/itenium-be/Git-NumberedAdd/releases/tag/v1.1'

    }
}

# HelpInfo URI of this module
HelpInfoURI = 'https://itenium.be/blog/dev-setup/git-numbered-add-for-powershell/'

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''
}
