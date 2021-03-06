<#	
.SYNOPSIS
	This Module was created by the TrueSec Infrastructure team to address and communicate various pieces of information. 

.DESCRIPTION
    This module contains various functions that have been build by the TrueSec infrastructure team. All functions are maintained in the associated PSM1 file.
    Each function has an associated updated function library file that is part of the child folder structure. The library folder structure can be used to updated
    or override a particular function if needed and is where testing individual change to the overall module will be completed. 

.EXAMPLE
	import-module TrueSec

.NOTES
    FileName:    TrueSecInfra.psd1
    Author:      TrueSec Infrastructure
    Contact:     @TrueSec_SE
    Created:     11/19/2019
    Updated:     11/19/2019

    Version history:
    0.0.0.2 - Updated to use new coding standard for myself

    #TODO: Create Folder Structure for Code and first set of functions
#>

@{
	
	# Script module or binary module file associated with this manifest
	ModuleToProcess = 'TrueSecInfra.psm1'
	
	# Version number of this module.
	ModuleVersion = '0.0.0.3'
	
	# ID used to uniquely identify this module
	GUID = 'f8509a48-8991-40e4-a721-51ae84c4bfc3'
	
	# Author of this module
	Author = 'Jordan Benzing'
	
	# Copyright statement for this module
	Copyright = '(c) 2019. All rights reserved.'
	
	# Description of the functionality provided by this module
	Description = 'Powershell Module for TrueSec Infrastructure tasks'
	
	# Minimum version of the Windows PowerShell engine required by this module
	PowerShellVersion = '5.1'
	
	# Name of the Windows PowerShell host required by this module
	PowerShellHostName = ''
	
	# Minimum version of the Windows PowerShell host required by this module
	PowerShellHostVersion = ''
	
	# Minimum version of the .NET Framework required by this module
	DotNetFrameworkVersion = '2.0'
	
	# Minimum version of the common language runtime (CLR) required by this module
	CLRVersion = '2.0.50727'
	
	# Processor architecture (None, X86, Amd64, IA64) required by this module
	ProcessorArchitecture = 'None'
	
	# Modules that must be imported into the global environment prior to importing
	# this module
	RequiredModules = @()
	
	# Assemblies that must be loaded prior to importing this module
	RequiredAssemblies = @()
	
	# Script files (.ps1) that are run in the caller's environment prior to
	# importing this module
	ScriptsToProcess = @()
	
	# Type files (.ps1xml) to be loaded when importing this module
	TypesToProcess = @()
	
	# Format files (.ps1xml) to be loaded when importing this module
	FormatsToProcess = @()
	
	# Modules to import as nested modules of the module specified in
	# ModuleToProcess
	NestedModules = @()
	
	# Functions to export from this module
	FunctionsToExport = "*" #For performanace, list functions explicity
	
	# Cmdlets to export from this module
	CmdletsToExport = ''
	
	# Variables to export from this module
	VariablesToExport = '*'
	
	# Aliases to export from this module
	AliasesToExport = '*' #For performanace, list alias explicity
	
	# List of all modules packaged with this module
	ModuleList = @()
	
	# List of all files packaged with this module
	FileList = @()
	
	# Private data to pass to the module specified in ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
	PrivateData = @{
		
		#Support for PowerShellGet galleries.
		PSData = @{
			
			# Tags applied to this module. These help with module discovery in online galleries.
			# Tags = @()
			
			# A URL to the license for this module.
			# LicenseUri = ''
			
			# A URL to the main website for this project.
			# ProjectUri = ''
			
			# A URL to an icon representing this module.
			# IconUri = ''
			
			# ReleaseNotes of this module
			# ReleaseNotes = ''
			
		} # End of PSData hashtable
		
	} # End of PrivateData hashtable
}







