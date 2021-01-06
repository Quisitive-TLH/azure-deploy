######################################################
# To run this, use browser and go to http://boxstarter.org/package/nr/url?http://boxstarter.org/package/nr/url?https://raw.githubusercontent.com/travis-hofmeister-quisitive/azure-deploy/master/code/infrastructure/arm/workstation/boxstarter-workstation.ps1
######################################################
# instructions at http://boxstarter.org/Learn/WebLauncher

# Boxstarter Options
$Boxstarter.RebootOk=$true # Allow reboots?
$Boxstarter.NoPassword=$false # Is this a machine with no login password?
$Boxstarter.AutoLogin=$true # Save my password securely and auto-login after a reboot

# Boxstarter (not Chocolatey) commands
Update-ExecutionPolicy Unrestricted
# Enable-RemoteDesktop  # already enabled on Azure VMs and no thanks for my laptop.
Disable-InternetExplorerESC  #Turns off IE Enhanced Security Configuration that is on by default on Server OS versions
Disable-UAC  # until this is over

disable-computerrestore -drive "C:\"  # http://ss64.com/ps/disable-computerrestore.html  

Disable-MicrosoftUpdate # until this is over
Disable-BingSearch # forever
Enable-RemoteDesktop

try {
  # https://github.com/chocolatey/choco/issues/52
  #choco feature enable -n=allowGlobalConfirmation

  mkdir c:\temp -Confirm:0 -ErrorAction Ignore

  $repoCoreDir = "C:\repos"
  mkdir "$repoCoreDir" -Confirm:0 -ErrorAction Ignore
  mkdir "$repoCoreDir\github" -Confirm:0 -ErrorAction Ignore
  mkdir "$repoCoreDir\github\AzureArchitecture" -Confirm:0 -ErrorAction Ignore

  $Boxstarter.Log="C:\temp\boxstarter.log"
  $Boxstarter.SuppressLogging=$false


  ######################################################
  # settings-system.ps1
  ######################################################
  #--- Enable developer mode on the system ---
  Set-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\AppModelUnlock -Name AllowDevelopmentWithoutDevLicense -Value 1


  Write-Output "Modifying Explorer options"
  Set-WindowsExplorerOptions -EnableShowFileExtensions -EnableShowFullPathInTitleBar
 
  #Write-Output "Modifying taskbar options"
  Set-BoxstarterTaskbarOptions -Dock Bottom -Combine Always -AlwaysShowIconsOn

  ######################################################
  # Installing Dev Tools
  ######################################################
  Write-Host "Installing Dev Tools"
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
  Write-Host

  <#
  choco install sysinternals -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache" 
  choco install rdcman -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache" 
  choco install gitbook-editor -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache" 
  choco install textgenerator -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache"
  choco install trailingwhitespace -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache"
  choco install webextensionpack -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache"
  choco install extensibilitytools -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache"
  choco install atom -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache"
  choco install filezilla -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache"
  choco install paint.net -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache"
  choco install chocolateygui -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache"
  choco install fiddler -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache"
  choco install azure-documentdb-emulator -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache"
  choco install azure-devops-policy-configurator -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache"
  choco install ignorefiles -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache"
  choco install imagesprites -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache"
  choco install openinvscode -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache"
  choco install packageinstaller -y --cacheLocation "$env:UserProfile\AppData\Local\ChocoCache"
  #>   

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

#
# Function for refreshing environment variables
#
function RefreshEnvironment() {
    foreach($envLevel in "Machine","User") {
        [Environment]::GetEnvironmentVariables($envLevel).GetEnumerator() | ForEach-Object {
            # For Path variables, append the new values, if they're not already in there
            if($_.Name -match 'Path$') {
               $_.Value = ($((Get-Content "Env:$($_.Name)") + ";$($_.Value)") -Split ';' | Select-Object -Unique) -Join ';'
            }
            $_
         } | Set-Content -Path { "Env:$($_.Name)" }
    }
}
#
# Function to create a path if it does not exist
#
function CreatePathIfNotExists($pathName) {
    if(!(Test-Path -Path $pathName)) {
        New-Item -ItemType directory -Path $pathName
    }
}
#
# Function to Download and Extract ZIP Files for CLIs and the likes
#
function DownloadAndExtractZip($link, $targetFolder, $tempName) {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    $downloadPath = ($env:TEMP + "\$tempName")
    if(!(Test-Path -Path $downloadPath)) {
        Invoke-WebRequest $link -OutFile $downloadPath
    }
    $shell = New-Object -ComObject Shell.Application
    $targetZip = $shell.NameSpace($downloadPath)

    CreatePathIfNotExists($targetFolder)
    foreach($item in $targetZip.items()) {
        $shell.Namespace($targetFolder).CopyHere($item)
    }
}
#
# Function to Download and Copy Files to location
#
function DownloadAndCopy($link, $targetFolder) {
    CreatePathIfNotExists($targetFolder)

    if(!(Test-Path -Path $targetFolder)) {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest $link -OutFile $targetFolder
    }
}
#
# Function to Download and ExecuteMSI
#
function DownloadAndInstallMsi($link, $targetFolder, $targetName) {
    CreatePathIfNotExists($targetFolder)

    $targetName = [System.IO.Path]::Combine($targetFolder, $targetName)

    if(!(Test-Path -Path $targetName)) {
        Invoke-WebRequest $link -OutFile $targetName
    }

    # Execute the MSI
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$targetName`" /passive" -Wait

    # After completed, delete the MSI-package, again
    Remove-Item -Path $targetName
}
#
# Function to Download and Execute exe
#
function DownloadAndInstallExe($link, $targetFolder, $targetName, $targetParams) {
    # .\FiddlerSetup.exe /S /D=C:\tools\Fiddler
    CreatePathIfNotExists($targetFolder)

    $targetName = [System.IO.Path]::Combine($targetFolder, $targetName)

    if(!(Test-Path -Path $targetName)) {
        Invoke-WebRequest $link -OutFile $targetName
    }

    # Execute the Installer-EXE
    Start-Process -FilePath "$targetName" -ArgumentList "$targetParams" -Wait

    # After completed, delete the MSI-package, again
    Remove-Item -Path $targetName
}
