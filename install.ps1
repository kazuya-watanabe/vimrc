$ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition

(Get-Item -Path "$env:USERPROFILE\vimfiles").Delete()
New-Item -Force -ItemType Junction -Target "$ScriptPath\.vim" -Path "$env:USERPROFILE\vimfiles"
