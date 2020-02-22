  <#
      .SYNOPSIS
      This script deploys the ADAP platform based on the values in the adap-cmdb.xlsx spreadsheet.

      .PARAMETER -azAll -adUsers -adGroups -azPolicies -azInitiatives -azRoles -azRoleAssignments -azActionGroups -azAlerts -azBlueprints -azParameterFiles
      Switch to deploy the resources

      .PARAMETER debugAction (default off)
      Switch to enable debugging output

      .PARAMETER actionVar (default SilentlyContinue)
      Switch to enable debugging output

      .PARAMETER env (default dev)
      token for deployment (smoke, dev, prod, uat, sandbox)

      .PARAMETER suffix (default eus)
      token for deployment

      .PARAMETER location (default centralus)
      location for Azure Blueprint deployment

      .PARAMETER alertResourceGroup (default rg-yazy-shared-dev-pcus)
      Resource group to deploy Azure Alerts to

      .PARAMETER action (default create)
      Create Azure Assets or Purge Azure Assets

      .PARAMETER removeRG (default $false)
      Switch to remove resource groups during blueprint purge

      Stop: Displays the error message and stops executing.
      Inquire: Displays the error message and asks you whether you want to continue.
      Continue: (Default) Displays the error message and continues executing.
      Suspend: Automatically suspends a work-flow job to allow for further investigation. After investigation, the work-flow can be resumed.
      SilentlyContinue: No effect. The error message isn't displayed and execution continues without interruption.

      .EXAMPLE
      .\deploy-adap-platform -orgTag "yazy" -deployAction "audit" -azAll
      .\deploy-adap-platform.ps1 -adGroups -adUsers -azPolicies -azInitiatives -azAlerts -azRoles -azRoleAssignments -azBlueprints
      .\deploy-adap-platform.ps1 -azAll -deployAction create
      .\deploy-adap-platform.ps1 -azAll -location "centralus" -env "dev" -actionVerboseVariable "SilentlyContinue" -actionDebugVariable "SilentlyContinue" -actionErrorVariable "SilentlyContinue" -deployAction create
      .\deploy-adap-platform.ps1 -azBlueprints -location "centralus" -env "dev" -actionVerboseVariable "Continue" -actionDebugVariable "Continue" -actionErrorVariable "Stop" -deployAction create

  #>
  param(
      # ortTag
    [string]$orgTag="yazy",

    # azAll
    [Switch]$azAll=$false,

    # adUsers
    [Switch]$adUsers=$false,

    # adGroups
    [Switch]$adGroups=$false,

    # azPolicies
    [Switch]$azPolicies=$false,

    # azInitiatives
    [Switch]$azInitiatives=$false,

    #azRoles
    [Switch]$azRoles=$false,

    #azBlueprints
    [Switch]$azBlueprints=$false,

    #AzRoleAssignments
    [Switch]$azRoleAssignments=$false,

    # azActionGroups
    [Switch]$azActionGroups=$false,

    # azAlerts
    [Switch]$azAlerts=$false,

    # azRunbooks
    [Switch]$azRunbooks=$false,

    # azParameterFiles
    [Switch]$azParameterFiles=$true,

    # debugAction
    [Switch]$debugAction = $false,

    # deployAction
    [validateset('create','purge')]
    [string]$deployAction = 'create',

    # adapCMDB
    [string]$adapCMDBfile = 'adap-cmdb.xlsm',

    # removeRG
    [switch]$removeRG=$false,


    # verbosePreferenceVariable
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [validateset('Stop','Inquire','Continue','Suspend','SilentlyContinue')]
    [string]$verbosePreferenceVariable = 'SilentlyContinue',

    # errorActionPreferenceVariable
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [validateset('Stop','Inquire','Continue','Suspend','SilentlyContinue')]
    [string]$errorActionPreferenceVariable = 'Stop',

    # debugPreferenceVariable
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [validateset('Stop','Inquire','Continue','Suspend','SilentlyContinue')]
    [string]$debugPreferenceVariable = 'SilentlyContinue',

    # informationPreferenceVariable
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [validateset('Stop','Inquire','Ignore','Continue','Suspend','SilentlyContinue')]
    [string]$informationPreferenceVariable = 'Continue',

    # confirmPreferenceVariable
    [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
    [validateset('None','Low','Medium','High')]
    [string]$confirmPreferenceVariable = 'None'

  )

  Clear-Host
  Set-Location -Path "$PSScriptRoot"
  Get-ChildItem C:\repos -recurse | Unblock-File 
  try{
    Set-ExecutionPolicy Unrestricted -Confirm:0 -Force -ErrorAction SilentlyContinue
  }
  Catch
  {}
  $firstRunCheck = $false
  
  #$null = "$actionErrorVariable"
  $VerbosePreference = $verbosePreferenceVariable
  $DebugPreference = $debugPreferenceVariable
  $ErrorActionPreference = $errorActionPreferenceVariable
  $InformationPreference = $informationPreferenceVariable
  $WarningPreference = $verbosePreferenceVariable
  $ConfirmPreference = $confirmPreferenceVariable
  $psscriptsRoot = $PSScriptRoot

  #Folder Locations
  $rootAzuredeploy = "$psscriptsRoot\..\..\..\..\..\"
  $psInfrastructureDirectory = "$psscriptsRoot\..\..\..\..\"
  $psCommonDirectory = "$psscriptsRoot\common"
  $psConfigDirectory = "$psscriptsRoot\config"
  $psAzureDirectory = "$psscriptsRoot"
  $armTemplatesDirectory = "$psscriptsRoot\..\..\..\arm\templates"
  $armAlertDirectory = "$psscriptsRoot\..\..\..\arm\alert"
  $armBluePrintDirectory = "$psscriptsRoot\..\..\..\arm\blueprint"
  $armPolicyDirectory = "$psscriptsRoot\..\..\..\arm\policy"
  $armRBACDirectory = "$psscriptsRoot\..\..\..\arm\rbac\roles"
  $armRunbookDirectory = "$psscriptsRoot\..\..\..\arm\automation\runbooks"



  $adapCMDB = "$psConfigDirectory\$adapCMDBfile"

  if ( -not (Test-path ('{0}\azure-common.psm1' -f "$psCommonDirectory")))
  {
    Write-Information 'Shared PS modules can not be found, Check path {0}\azure-common.psm1.' -f $psCommonDirectory
    Exit
  }
  ## Check path to CMDB
  if ( -not (Test-path -Path $adapCMDB))
  {
    Write-Information  'No file specified or file {0}\{1} does not exist.' -f $psConfigDirectory, $adapCMDBfile
    Exit
  }

  try{
    $azureCommon = ('{0}\{1}' -f  $psCommonDirectory, 'azure-common.psm1')
    Import-Module -Name $azureCommon -Force 

    #Set Config Values
    $configurationFile = ('{0}\{1}' -f  $psConfigDirectory, 'adap-configuration.psm1')
    Import-Module -Name $configurationFile -Force 
    $config = Get-Configuration
  }
  catch {
    Write-Host -ForegroundColor RED    "Error importing reguired PS modules: $azureCommon, $configurationFile"
    $PSCmdlet.ThrowTerminatingError($_)
    Exit
  }
  
  # Set variabls from config file
  $automationAccountName = $config.laAutomationAccount
  $logAnalytics = $config.laWorkspaceName
  $alertResourceGroup = $config.alertResourceGroup
  $orgTagDefault = $config.orgTag
  $env = $config.evTag
  $location = $config.primaryLocation
  $adOUPath = $config.adOUPath
  $suffix = $config.suffix
  $subscriptionId = $config.subscriptionId
  $subscriptionIdZero = "00000000-0000-0000-0000-000000000000"
    
  # define resource groups 
  $testRG = $config.testResourceGroup
  $smokeRG = $config.smokeResourceGroup
  $mgmtRG = $config.mgmtResourceGroup
  $networkRG = $config.networkResourceGroup
  $sharedRG = $config.sharedResourceGroup
  $adapRG = $config.adapResourceGroup
  $onpremRG  = $config.onpremResourceGroup


  
  Set-Location -Path "$rootAzuredeploy"

      # Only run this the first time through.
  if (!$firstRunCheck) {  
    # load PS modules
    
    Write-Information 'Logon to Azure (MFA)...'
    Initialize-Subscription -Force
    $subscriptionId = Get-SubscriptionId
    $subscriptionName = Get-SubscriptionName
    $accountId = Get-AccountId
    $tenantId = Get-TenantId
        
    try{
        Add-Type -AssemblyName Microsoft.Open.AzureAD16.Graph.Client
        # Logon to Azure AD with values from config file
        Write-Information 'Logon to Azure Active Directory...'
        Connect-AzureAD -TenantId $tenantId -AccountId $accountId
    }
    catch{
      Write-Host 'Logon to Azure Active Directory Failed'
      Write-Host -Message 'Press any key to exit...'
      Exit
    }
    $firstRunCheck = $true
  }
  

  Set-Location -Path "$psscriptsRoot"  
      
  # Start Deployment of Azure Assets
  Write-Information 'Starting deployment of Azure Assets'
    
  Set-Location -Path $psscriptsRoot
  # Completing Deployment of Azure Assets
  Write-Information 'Completing deployment of Azure Assets'

  # Remove variable
  #((Compare-Object -ReferenceObject (Get-Variable).Name -DifferenceObject $DefaultVariables).InputObject).foreach{Remove-Variable -Name $_}