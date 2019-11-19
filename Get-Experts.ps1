# Get-Experts

#Get Env:
$RootFolder = $MyInvocation.MyCommand.Path | Split-Path -Parent
$RootFolder = "D:\Repo\Get-Experts"
#Get LData
$XMLLDatafile = "$RootFolder\lConfig.XML"
[XML]$XMLLData = Get-Content -Path $XMLLDatafile

#Get Data
$XMLDatafile = $XMLLData.Settings.XMLFile
[XML]$XMLData = (New-Object System.Net.WebClient).DownloadString($XMLDatafile)

$XMLData.Data.Experts.Expert
