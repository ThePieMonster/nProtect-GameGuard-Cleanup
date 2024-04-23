<#
.SYNOPSIS
	Clean Up nProtect GameGuard Cache Files.
.DESCRIPTION
	This PowerShell script will use the common nProtect GameGuard paths to remove .erl files.
.EXAMPLE
	PS> ./nProtect-GameGuard-Cleanup.ps1
.LINK
	https://github.com/ThePieMonster/nProtect-GameGuard-Cleanup
.NOTES
	Author: ThePieMonster

    If you get a error about running scripts on your machine then you need to run the below:
    Set-ExecutionPolicy Unrestricted -Force
    
    If you would like to disable scripts then you can run the below:
    Set-ExecutionPolicy Default -Force
#>


# User Variables
$steamGamePaths = @("C:\Program Files (x86)\Steam\steamapps\common", "C:\Program Files\Steam\steamapps\common")




# *** Do Not Edit Below This Line Unless You Know What You Are Doing ***
# Setup Script
$ErrorActionPreference = "Stop"

# Get list of Steam games
Foreach($path in $steamGamePaths) {
    $steamGames = Get-ChildItem -Path $path -Directory -Force -ErrorAction SilentlyContinue

    # Cleanup nProtect GameGuard Files
    Foreach($sPath in $steamGames) {
        # create path
        $steamGameGameGuardPath = $sPath.FullName + "\bin\GameGuard"
    
        # check for GameGuard Directory
        if(Test-Path $steamGameGameGuardPath) {
            Write-Host "Found GameGuard Directory for Steam game: $sPath"
    
            # Grab list of .erl files
            $erls = Get-ChildItem -Path $steamGameGameGuardPath -Filter *.erl
            Write-Host "Found" $erls.Count "ERL files"

            # Delete ERLs
            $i = 0
            Foreach($erl in $erls){
                try{
                    Remove-Item $erl.FullName -Force
                    $i++
                } catch {
                    #Write-Host "⚠️ Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])" -ForegroundColor Red
                    Write-Host "Error trying to delete:" $erl.FullName -ForegroundColor Red
                }
                Write-Host "Removed $i ERL files"
            }
        }
    }
}
