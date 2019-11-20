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

        COMPLETE: Import the XML infromation about the various TrueSec users.
        TODO: Merge to TrueSec Infrastructure Module 

.EXAMPLE
    Get-TSxExperts

#>

[cmdletbinding()]
param(
    [Parameter(HelpMessage = "Proivde the link to where the Expert Data File lives on the internet in XML Format.")]
    [string]$ExpertStorage = "https://raw.githubusercontent.com/DeploymentBunny/Get-TSxExperts/master/Functions/Get-TSxExperts/ExpertDataFile.xml",
    [Parameter(HelpMessage = "Boolean that allow you to only return currently active TrueSec Experts")]
    [ValidateSet("True","False","Both")]
    [string]$Active = "Both",
    [Parameter(HelpMessage = "Returns the list of competency choices",ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [array]$Competency,
    [Parameter(HelpMessage = "This Parameter returns all information, otherwise returns abridged properties.")]
    [switch]$Full
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
    $DataReturn = $null
    [XML]$XMLData = (New-Object System.Net.WebClient).DownloadString($ExpertStorage)
    $DataReturn = $XMLData.Data.Experts.Expert 
    #Paramater for returning Active members
    if($Active -eq "True"){
        $DataReturn = $DataReturn | Where-Object {$_.active -eq $true} | Format-Table -AutoSize
    }
    if($Active -eq "False"){
        $DataReturn = $DataReturn | Where-Object {$_.active -eq $false} | Format-Table -AutoSize
    }

    #Parameter for returning consultants with matching competency
    if($Competency){
        $DataReturn = $DataReturn | Where-Object {$_.competency -contains $Competency} 
    }
    if($Full){
        $DataReturn
    }
    else{
        $DataReturn | Select-Object Name,Contact,Twitter,ShortDescription
    }
}
