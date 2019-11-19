<#
.SYNOPSIS
    This script gets information about the TrueSec Infrastructure Experts.
.DESCRIPTION
    This function is a part of the module TrueSecInfra and is used to update the PowerShell Module TrueSecInfra when it is updated. 
.LINK
    https://github.com/DeploymentBunny/Get-TSxExperts

.NOTES
          FileName: Get-TSxExperts.ps1
          Author: Mikael Nystrom , Jordan Benzing
          Contact: @Nystrom_Mikael , @JordanTheItGuy
          Created: 2019-11-19
          Modified: 2019-11-19

          Version - 0.0.0.1 - (2019-11-19)


        #TODO: Import the XML infromation about the various TrueSec users.
        #TODO: Create way to update the XML file.
        #TODO: Merge to TrueSec Infrastructure Module 

.EXAMPLE
    Get-TSxExperts

#>

function Get-TSxExperts{
[cmdletbinding()]
param(
    [Parameter(HelpMessage = "Proivde the link to where the Expert Data File lives on the internet in XML Format.")]
    [string]$ExpertStorage = "https://raw.githubusercontent.com/DeploymentBunny/Get-TSxExperts/master/Functions/Get-TSxExperts/ExpertDataFile.xml",
    [Parameter(HelpMessage = "Boolean that allow you to only return currently active TrueSec Experts" )]
    [bool]$Active,
    [Parameter(HelpMessage = "Returns the list of competency choices")]
    [string]$Competency
)
begin{
    try{
        #Get Data from storage blob
        [XML]$XMLData = (New-Object System.Net.WebClient).DownloadString($ExpertStorage)
    }
    catch{
        Write-Error "Unable to downlaod the expert list"
    }
}
process{
    #Downlaod the XMLData in the running process and store
    #Forcibly Purge the XMLData information as it does not re-build properly
    $XMLData = $null
    [XML]$XMLData = (New-Object System.Net.WebClient).DownloadString($ExpertStorage)
    foreach($Item in $XMLData.Data.Experts.Expert){
        $Item
    }
}

}
Get-TSxExperts