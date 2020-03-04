Function Write-TSxLog {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Message,
        [Parameter()]
        [ValidateSet(1, 2, 3)]
        [string]$LogLevel = 1,
        [Parameter(Mandatory = $false)]
        [bool]$writetoscreen = $true,
        [Parameter(HelpMessage = "Enter the path to the log folder and it will change dynamically")]
        [string]$LogFoldderPath,
        [Parameter(HelpMessage = "Enter the log file name")]
        [string]$LogFileName  
    )
    if($LogFileName -and $LogFoldderPath){
        set-TSxLogPath -LogFolderPath $LogFoldderPath -LogFileName $LogFileName
    }
    elseif($LogFoldderPath){
        set-TSxLogPath -LogFolderPath $LogFoldderPath
    }
    elseif($LogFileName){
        set-TSxLogPath -LogFileName $LogFileName
    }
    if(!($Global:LogFile)){
        set-TSxLogPath
    }
    $TimeGenerated = "$(Get-Date -Format HH:mm:ss).$((Get-Date).Millisecond)+000"
    $Line = '<![LOG[{0}]LOG]!><time="{1}" date="{2}" component="{3}" context="" type="{4}" thread="" file="">'
    if($MyInvocation.ScriptName){
        $LineFormat = $Message, $TimeGenerated, (Get-Date -Format MM-dd-yyyy), "$($MyInvocation.ScriptName | Split-Path -Leaf):$($MyInvocation.ScriptLineNumber)", $LogLevel
    }
    else{
        $LineFormat = $Message, $TimeGenerated, (Get-Date -Format MM-dd-yyyy), "EXECUTED BY:$($ENV:USERNAME)", $LogLevel
    }
    $Line = $Line -f $LineFormat
    [system.GC]::Collect()
    Add-Content -Value $Line -Path $Global:LogFile
    if ($writetoscreen) {
        switch ($LogLevel) {
            '1' {
                Write-Verbose -Message $Message
            }
            '2' {
                Write-Warning -Message $Message
            }
            '3' {
                Write-Error -Message $Message
            }
            Default {
            }
        }
    }
    if ($writetolistbox -eq $true) {
        $result1.Items.Add("$Message")
    }
}

function set-TSxLogPath {
    [CmdletBinding(DefaultParameterSetName = 'None')]
    param
    (
        [parameter(Mandatory = $true,ParameterSetName = 'LogName')]
        [string]$LogFolderPath,
        [Parameter(Mandatory = $False, HelpMessage = "Enter the log file name",ParameterSetName = 'LogName')]
        [string]$LogFileName
    )
    if($LogFileName){
        if($LogFileName.Substring($($LogFileName.Length - 3) -ieq "LOG")){
            $LogFile = $LogFileName
        }
        else{
            $LogFile = "$($LogFileName).log"
        }
    }
    else{
        if($LogFolderPath){
            if (Test-Path -Path $LogFolderPath) {
                if ($MyInvocation.ScriptName) {
                    Write-Warning -Message "We were not supposed to get here...$($MyInvocation.ScriptName)"
                    $LogFile = "$($($script:MyInvocation.MyCommand.Name).Substring(0,$($script:MyInvocation.MyCommand.Name).Length-4)).log"
                }
                else {
                    $LogFile = "$($ENV:TEMP)\TSXModule.log"
                    Write-Warning -Message "You are running inside ISE - all commands will be logged to: $($LogFile)"
                }
            }
        }
        else {
            $LogFile = "$($ENV:TEMP)\TSXModule.log"
            Write-Warning -Message "You specified a path that doesn't exist - all commands will be logged to: $($LogFile)"
        }
    }
    $Global:LogFile = $LogFile
    try {
        #Confirm the provided destination for logging exists if it doesn't then create it.
        if (!(Test-Path $Global:LogFile)) {
            ## Create the log file destination if it doesn't exist.
            New-Item $Global:LogFile -Type File | Out-Null
        }
    }
    catch {
        #In event of an error write an exception
        Write-Error $_.Exception.Message
    }
}
