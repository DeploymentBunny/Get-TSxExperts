Function Write-TSxLog {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Message,
        [Parameter(HelpMessage = "Enter the log level", Mandatory = $false)]
        [ValidateSet(1, 2, 3)]
        [string]$LogLevel = 1,
        [Parameter(HelpMessage = "This variable enables you to turn off writing the logged message to the screen it is on by default." , Mandatory = $false)]
        [bool]$writetoscreen = $true,
        [Parameter(HelpMessage = "Enter the path to the log folder and it will change dynamically")]
        [string]$LogFoldderPath,
        [Parameter(HelpMessage = "Enter the log file name")]
        [string]$LogFileName  
    )
    if ($LogFileName -and $LogFoldderPath) {
        set-TSxLogPath -LogFolderPath $LogFoldderPath -LogFileName $LogFileName
    }
    elseif ($LogFoldderPath) {
        set-TSxLogPath -LogFolderPath $LogFoldderPath
    }
    elseif ($LogFileName) {

        set-TSxLogPath -LogFileName $LogFileName
    }
    if (!($Global:TSxCurrentLogFile)) {
        set-TSxLogPath
    }
    $TimeGenerated = "$(Get-Date -Format HH:mm:ss).$((Get-Date).Millisecond)+000"
    $Line = '<![LOG[{0}]LOG]!><time="{1}" date="{2}" component="{3}" context="" type="{4}" thread="" file="">'
    if ($MyInvocation.ScriptName) {
        $LineFormat = $Message, $TimeGenerated, (Get-Date -Format MM-dd-yyyy), "$($MyInvocation.ScriptName | Split-Path -Leaf):$($MyInvocation.ScriptLineNumber)", $LogLevel
    }
    else {
        $LineFormat = $Message, $TimeGenerated, (Get-Date -Format MM-dd-yyyy), "EXECUTED BY:$($ENV:USERNAME)", $LogLevel
    }
    $Line = $Line -f $LineFormat
    [system.GC]::Collect()
    Add-Content -Value $Line -Path $Global:TSxCurrentLogFile -Force
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
        [parameter(Mandatory = $False, ParameterSetName = 'LogName')]
        [string]$LogFolderPath,
        [Parameter(Mandatory = $False, HelpMessage = "Enter the log file name", ParameterSetName = 'LogName')]
        [string]$LogFileName
    )
    begin {
        if (!($Global:TSxDefaultlogFile)) {
            New-Variable -Name TSxDefaultLogFile -Value "$($ENV:TEMP)\TSxModule.log" -Scope Global
        }
    }
    process {
        #region SetLogfileName
        if ($LogFileName) {
            if ($($LogFileName.Substring($($LogFileName.Length - 3)) -eq "log")) {
                $LogFile = $LogFileName
            }
            else {
                $LogFile = "$($LogFileName).log"
            }
        }
        else {
            if ($script:MyInvocation) {
                $callstack = Get-PSCallStack
                $LogFile = "$($($callstack[$callstack.Length-2].InvocationInfo.MyCommand.Name).Substring(0,$($callstack[$callstack.Length-2].InvocationInfo.MyCommand.Name).Length-4)).log"
                $Global:CallStack = $callstack
            }
            else {
                $LogFile = "TSXModule.log"
                Write-Warning -Message "You are running inside ISE - all commands will be logged to: $($LogFile)"
            }
        }
        #endregion SetLogFileName

        #Region SetLogFolderName
        if ($LogFolderPath) {
            $FullLogFile = "$($LogFolderPath)\$($logFile)"
            Write-Debug -Message "This log has not been used before now initializing the path"
            if ($(Get-Variable -Name "TSx*" | Where-Object { $_.Value -like "*$($LogFile)" })) {
                $Global:TSxCurrentLogFile = $(Get-Variable -Name "TSX*$($LogFile)" | Where-Object { $_.Value -like "*$($LogFile)" }).Value
            }
            else {
                New-Variable -Name "TSx$($LogFile)" -Scope Global -Value $FullLogFile
                $Global:TSxCurrentLogFile = $(Get-Variable -Name "TSX*$($LogFile)" | Where-Object { $_.Value -like "*$($LogFile)" }).Value
            }
        }
        elseif ($PSScriptRoot) {
            $Name = $CallStack[-2].InvocationInfo.MyCommand.Name
            $Source = $CallStack[-2].InvocationInfo.MyCommand.Source
            $LogFolderPath = $Source.Replace($Name, "")
            $Global:TSxCurrentLogFile = "$($LogFolderPath)$($Logfile)"
        }
        else {
            if ($(Get-Variable -Name "TSx*" | Where-Object { $_.Value -like "*$($LogFile)" })) {
                $Global:TSxCurrentLogFile = $(Get-Variable -Name "TSX*$($LogFile)" | Where-Object { $_.Value -like "*$($LogFile)" }).Value
            }
            else {
                Write-Warning -Message "You specified a log that doesn't exist, or hasn't been declared - all commands will be logged to: $($Global:TSxDefaultlogFile)"
                $Global:TSxCurrentLogFile = $Global:TSxDefaultLogFile
            }
        }
        #endregion SetLogFolderName
        try {
            #Confirm the provided destination for logging exists if it doesn't then create it.
            if (!(Test-Path $Global:TSxCurrentLogFile)) {
                ## Create the log file destination if it doesn't exist.
                New-Item $Global:TSxCurrentLogFile -Type File | Out-Null
            }
        }
        catch {
            #In event of an error write an exception
            Write-Error $_.Exception.Message
        }
    }
}