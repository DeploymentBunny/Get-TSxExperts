<#
.SYNOPSIS
    Get the TrueSec Competency list of every skill the organization TrueSec has. 

.DESCRIPTION
    This function will run to get the various competency options that TrueSec infrastructure supports. This cmdlet then allows you to
    to pipe the information to the Get-TSxExperts. This cmdlet uses no pipelines.

.LINK


.NOTES
          FileName: Get-TSxCompetency.PS1
          Author: Jordan Benzing
          Contact: @JordanTheItGuy
          Created: 2019-11-20
          Modified: 2019-11-20

          Version - 0.0.0.1 - (2019-11-20)


          TODO:


.EXAMPLE
    Get-TSxCompetency
#>

[cmdletbinding()]
param(
)
begin{

}
process{
    [array]$Array = $(Get-TSxExperts -Properties Competency).Competency | Select-Object -Unique
    $Array
}
