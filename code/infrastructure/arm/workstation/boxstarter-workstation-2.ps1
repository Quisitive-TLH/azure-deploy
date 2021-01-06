######################################################
# To run this, use browser and go to http://boxstarter.org/package/nr/url?http://boxstarter.org/package/nr/url?https://raw.githubusercontent.com/travis-hofmeister-quisitive/azure-deploy/master/code/infrastructure/arm/workstation/boxstarter-workstation.ps1
######################################################
# instructions at http://boxstarter.org/Learn/WebLauncher

# Boxstarter Options
Write-Host "Boxstarter Options"
$Boxstarter.RebootOk=$true # Allow reboots?
$Boxstarter.NoPassword=$false # Is this a machine with no login password?
$Boxstarter.AutoLogin=$true # Save my password securely and auto-login after a reboot

# Boxstarter (not Chocolatey) commands
Write-Host "Update-ExecutionPolicy"
Update-ExecutionPolicy Unrestricted

Write-Host "Disable-InternetExplorerESC"
Disable-InternetExplorerESC  #Turns off IE Enhanced Security Configuration that is on by default on Server OS versions

Write-Host "Disable-UAC"
Disable-UAC  # until this is over

Write-Host "disable-computerrestore"
disable-computerrestore -drive "C:\"  # http://ss64.com/ps/disable-computerrestore.html  

Write-Host "Disable-MicrosoftUpdate"
Disable-MicrosoftUpdate # until this is over

Write-Host "Enable-RemoteDesktop"
Enable-RemoteDesktop

try {
  Write-Host "choco feature enable - start"
  # https://github.com/chocolatey/choco/issues/52
  #choco feature enable -n=allowGlobalConfirmation
  Write-Host "choco feature enable - end"

  
  Write-Host "make temp dir - start"
  mkdir c:\temp -Confirm:0 -ErrorAction Ignore
  Write-Host "make temp dir - end"

  Write-Host "make repos dir - start"
  $repoCoreDir = "C:\repos"
  mkdir "$repoCoreDir" -Confirm:0 -ErrorAction Ignore
  Write-Host "make repos dir - end"

  Write-Host "create boxstarter log - start"
  $Boxstarter.Log="C:\temp\boxstarter.log"
  $Boxstarter.SuppressLogging=$false
  Write-Host "create boxstarter log - end"

  ######################################################
  # settings-system.ps1
  ######################################################
  Write-Host "system settings - start"
  #--- Enable developer mode on the system ---
  Set-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\AppModelUnlock -Name AllowDevelopmentWithoutDevLicense -Value 1

  Write-Host "  Modifying Explorer options"
  Set-WindowsExplorerOptions -EnableShowFileExtensions -EnableShowFullPathInTitleBar
 
  #Write-Output "Modifying taskbar options"
  Set-BoxstarterTaskbarOptions -Dock Bottom -Combine Always -AlwaysShowIconsOn

  ######################################################
  # Installing Dev Tools
  ######################################################
  Write-Host "  Installing Dev Tools"
  choco install googlechrome -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache"
  choco install git.install -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache" 
  choco install visualstudio2019community --All -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache"
  choco install visualstudio2019-workload-azure --All -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache" 
  choco install azure-cli -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache" 
  choco install microsoftazurestorageexplorer -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache" 
  choco install vscode -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache" 
  choco install sql-server-management-studio -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache" 
  choco install ssis-vs2019 -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache" 
  choco install azure-data-studio -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache" 
  choco install azuredatastudio-powershell -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache" 
  choco install github-desktop -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache" 
  choco install adobereader -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache" 
  choco install office365proplus -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache" 
  choco install git-credential-manager-for-windows -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache" 
  choco install gitextensions -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache" 
  choco install vscode-powershell -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache"
  choco install vscode-mssql -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache"

  choco install azure-functions-core-tools -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache"
  choco install azure-data-studio-sql-server-admin-pack -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache"
  choco install vscode-azurerm-tools -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache"
  choco install azcopy10 -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache"
  choco install vscode-vsonline -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache"
  choco install azure-pipelines-agent -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache"
  choco install markdownmonster -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache"
  choco install vscode-azurerepos -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache"
  choco install opencommandline -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache"
  choco install codemaid -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache"
  choco install stylecop -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache"

  choco install sourcetree -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache"
  choco install 7zip.install -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache"
  Write-Output "system settings - end"
  Write-Host

  ######################################################
  # Taskbar icons
  ######################################################
  Write-Host "Adding Icons to the TaskBar"
  Install-ChocolateyPinnedTaskBarItem "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\IDE\devenv.exe"
  Install-ChocolateyPinnedTaskBarItem "%windir%\system32\WindowsPowerShell\v1.0\PowerShell_ISE.exe"
  Install-ChocolateyPinnedTaskBarItem "C:\Windows\explorer.exe"
  Install-ChocolateyPinnedTaskBarItem "%windir%\system32\cmd.exe"
  Install-ChocolateyPinnedTaskBarItem "C:\Program Files\Google\Chrome\Application\chrome.exe"

  %windir%\system32\cmd.exe

  ######################################################
  # Add to the path
  ######################################################
  Write-Host "Adding Git\bin to the path"
  $ENV:PATH="$ENV:PATH;C:\Program Files\Git\bin;C:\Program Files (x86)\Microsoft SDKs\Azure\AzCopy;"
  Write-Host

  $repoCoreDir = "C:\repos"
  #cd "$repoCoreDir\github\AzureArchitecture"
  #git clone https://github.com/AzureArchitecture/azure-deploy.git
  
  ######################################################
  # installing windows updates
  ######################################################
  Write-Output "Installing Windows Updates"
  Enable-MicrosoftUpdate
  Install-WindowsUpdate -AcceptEula -GetUpdatesFromMS

  Read-Host "Restart required for some modifications to take effect. Please reboot."
}
catch {
  throw $_
}


#
# End of Chocolatey
#
###########################################################################################################