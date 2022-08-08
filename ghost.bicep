targetScope = 'resourceGroup'

@description('Prefix to use when creating the resources in this deployment.')
param applicationNamePrefix string = 'ghost'


@description('Dev App Service Plan pricing tier for dev')
param devAppServicePlanSku string = 'B1'

@description('Stage/Prod App Service Plan pricing tier')
param appServicePlanSku string = 'B1'

@description('Log Analytics workspace pricing tier')
param devLogAnalyticsWorkspaceSku string = 'PerGB2018'

@description('Stage/Prod Log Analytics workspace pricing tier')
param logAnalyticsWorkspaceSku string = 'PerGB2018'

@description('Dev Storage account pricing tier for dev')
param devStorageAccountSku string = 'Standard_LRS'

@description('Stage/Prod Storage account pricing tier')
param storageAccountSku string = 'Standard_LRS'


@description('Location to deploy the resources')
param location string = resourceGroup().location

@description('Dev MySQL server SKU for dev')
param devMySQLServerSku string = 'mySQLServerSku'

@description('Stage/Prod MySQL server SKU')
param mySQLServerSku string = 'mySQLServerSku'


@description('Dev MySQL server password')
@secure()
param devDatabasePassword string

@description('Stage MySQL server password')
@secure()
param stageDatabasePassword string

@description('Prod MySQL server password')
@secure()
param prodDatabasePassword string



@allowed([
  'Disabled'
  'Enabled'
])
@description('Stage/Prod Whether or not geo redundant backup is enabled.')
param geoRedundantBackup string

@allowed([
  'Disabled'
  'Enabled'
])
@description('Dev Whether or not geo redundant backup is enabled for dev')
param devGeoRedundantBackup string


@allowed([
  'Disabled'
  'SameZone'
  'ZoneRedundant'
])
@description('Stage/Prod High availability mode for a server.')
param highAvailabilityMode string


@allowed([
  'Disabled'
  'SameZone'
  'ZoneRedundant'
])
@description('Dev High availability mode for a server for dev')
param devHighAvailabilityMode string


@description('Ghost container full image name and tag')
param ghostContainerName string = 'gitarplayer/ghost-az-ai'

@allowed([
  'latest'
])
@description('Ghost container full image name and tag')
param devGhostContainerTag string = 'latest'

@allowed([
  'stage'
])
@description('Ghost container full image name and tag')
param stageGhostContainerTag string = 'stage'

@allowed([
  'prod'
])
@description('Ghost container full image name and tag')
param prodGhostContainerTag string = 'prod'




@description('Container registry where the image is hosted')
param containerRegistryUrl string = 'https://index.docker.io/v1'

@allowed([
  'Web app with Azure CDN'
  'Web app with Azure Front Door'
  'Web app dev'
])
param devDeploymentConfiguration string = 'Web app dev'

@allowed([
  'Web app with Azure CDN'
  'Web app with Azure Front Door'
  'Web app dev'
])
param stageDeploymentConfiguration string = 'Web app with Azure Front Door'

@allowed([
  'Web app with Azure CDN'
  'Web app with Azure Front Door'
  'Web app dev'
])
param prodDeploymentConfiguration string = 'Web app with Azure Front Door'

@minValue(30)
@maxValue(730)
param retentionInDays int = 90

@minValue(30)
@maxValue(90)
param devRetentionInDays int = 30




@allowed([
  'v4.0'
  'v5.0'
])
@description('Stage/Prod The ghost API version used for the azure function')
param ghostApiVersion string


@allowed([
  'v4.0'
  'v5.0'
])
@description('Dev The ghost API version used for the azure function for dev')
param devGhostApiVersion string

param devPkgURL string = 'https://github.com/GitarPlayer/azure-function-ghost/archive/refs/tags/0.0.6.zip'
param stagePkgURL string = 'https://github.com/GitarPlayer/azure-function-ghost/archive/refs/tags/0.0.6.zip'
param prodPkgURL string = 'https://github.com/GitarPlayer/azure-function-ghost/archive/refs/tags/0.0.6.zip'


param autoScaleMin string = '3'
param autoScaleMax string = '3'
param autoScaleDefault string = '3'
param autoScaleCPUTreshold int = 70
param scaleActionIncrease string = '3'

// vars


// prefixes
var http_prefix = 'https://'
var devPrefix = 'dev'
var stagePrefix = 'stage'
var prodPrefix = 'prod'

// resource name vars
var devWebAppName = '${devPrefix}-${applicationNamePrefix}-web-${uniqueString(resourceGroup().id)}'
var stageWebAppName = '${stagePrefix}-${applicationNamePrefix}-web-${uniqueString(resourceGroup().id)}'
var prodWebAppName = '${prodPrefix}-${applicationNamePrefix}-web-${uniqueString(resourceGroup().id)}'
var stageAutoScaleSettingName = '${stagePrefix}-${applicationNamePrefix}-scale-${uniqueString(resourceGroup().id)}'
var prodAutoScaleSettingName = '${prodPrefix}-${applicationNamePrefix}-scale-${uniqueString(resourceGroup().id)}'
var devFunctionName = '${devPrefix}-${applicationNamePrefix}-web-function-${uniqueString(resourceGroup().id)}'
var stageFunctionName = '${stagePrefix}-${applicationNamePrefix}-web-function-${uniqueString(resourceGroup().id)}'
var prodFunctionName = '${prodPrefix}-${applicationNamePrefix}-web-function-${uniqueString(resourceGroup().id)}'
var devAppServicePlanName = '${devPrefix}-${applicationNamePrefix}-asp-${uniqueString(resourceGroup().id)}'
var stageAppServicePlanName = '${stagePrefix}-${applicationNamePrefix}-asp-${uniqueString(resourceGroup().id)}'
var prodAppServicePlanName = '${prodPrefix}-${applicationNamePrefix}-asp-${uniqueString(resourceGroup().id)}'
var devLogAnalyticsWorkspaceName = '${devPrefix}-${applicationNamePrefix}-la-${uniqueString(resourceGroup().id)}'
var stageLogAnalyticsWorkspaceName = '${stagePrefix}-${applicationNamePrefix}-la-${uniqueString(resourceGroup().id)}'
var prodLogAnalyticsWorkspaceName = '${prodPrefix}-${applicationNamePrefix}-la-${uniqueString(resourceGroup().id)}'
var devApplicationInsightsName = '${devPrefix}-${applicationNamePrefix}-ai-${uniqueString(resourceGroup().id)}'
var stageApplicationInsightsName = '${stagePrefix}-${applicationNamePrefix}-ai-${uniqueString(resourceGroup().id)}'
var prodApplicationInsightsName = '${prodPrefix}-${applicationNamePrefix}-ai-${uniqueString(resourceGroup().id)}'
var devApplicationInsightsNameFunction = '${devPrefix}-${applicationNamePrefix}-ai-function-${uniqueString(resourceGroup().id)}'
var stageApplicationInsightsNameFunction = '${stagePrefix}-${applicationNamePrefix}-ai-function-${uniqueString(resourceGroup().id)}'
var prodApplicationInsightsNameFunction = '${prodPrefix}-${applicationNamePrefix}-ai-function-${uniqueString(resourceGroup().id)}'
var devKeyVaultName = '${devPrefix}-kv-${uniqueString(resourceGroup().id)}'
var stageKeyVaultName = '${stagePrefix}-kv-${uniqueString(resourceGroup().id)}'
var prodKeyVaultName = '${prodPrefix}-kv-${uniqueString(resourceGroup().id)}'
var devStorageAccountName = '${devPrefix}stor${uniqueString(resourceGroup().id)}'
var stageStorageAccountName = '${stagePrefix}stor${uniqueString(resourceGroup().id)}'
var prodStorageAccountName = '${prodPrefix}stor${uniqueString(resourceGroup().id)}'
var devMySQLServerName = '${devPrefix}-${applicationNamePrefix}-mysql-${uniqueString(resourceGroup().id)}'
var stageMySQLServerName = '${stagePrefix}-${applicationNamePrefix}-mysql-${uniqueString(resourceGroup().id)}'
var prodMySQLServerName = '${prodPrefix}-${applicationNamePrefix}-mysql-${uniqueString(resourceGroup().id)}'
var warmUpSlotName = '${prodPrefix}-${applicationNamePrefix}-warmup-${uniqueString(resourceGroup().id)}'



// other vars
var databaseLogin = 'ghost'
var databaseName = 'ghost'
var devGhostContentFileShareName = '${devPrefix}-contentfiles'
var stageGhostContentFileShareName = '${stagePrefix}-contentfiles'
var prodGhostContentFileShareName = '${prodPrefix}-contentfiles'
var ghostContentFilesMountPath = '/var/lib/ghost/content_files'

var stageSiteUrl = (stageDeploymentConfiguration == 'Web app with Azure Front Door') ? 'https://${stageFrontDoorName}.azurefd.net' : 'https://${stageCdnEndpointName}.azureedge.net'
var prodSiteUrl = (prodDeploymentConfiguration == 'Web app with Azure Front Door') ? 'https://${prodFrontDoorName}.azurefd.net' : 'https://${prodCdnEndpointName}.azureedge.net'


// TODO
// var devSiteUrl 

//Web app with Azure CDN
var stageCdnProfileName = '${stagePrefix}-${applicationNamePrefix}-cdnp-${uniqueString(resourceGroup().id)}'
var prodCdnProfileName = '${prodPrefix}-${applicationNamePrefix}-cdnp-${uniqueString(resourceGroup().id)}'
var stageCdnEndpointName = '${stagePrefix}-${applicationNamePrefix}-cdne-${uniqueString(resourceGroup().id)}'
var prodCdnEndpointName = '${prodPrefix}-${applicationNamePrefix}-cdne-${uniqueString(resourceGroup().id)}'
var cdnProfileSku = {
  name: 'Standard_Microsoft'
}

//Web app with Azure Front Door
var stageFrontDoorName = '${stagePrefix}-${applicationNamePrefix}-fd-${uniqueString(resourceGroup().id)}'
var prodFrontDoorName = '${prodPrefix}-${applicationNamePrefix}-fd-${uniqueString(resourceGroup().id)}'
var stageWafPolicyName = '${stagePrefix}${applicationNamePrefix}waf${uniqueString(resourceGroup().id)}'
var prodWafPolicyName = '${prodPrefix}${applicationNamePrefix}waf${uniqueString(resourceGroup().id)}'

module devLogAnalyticsWorkspace './modules/logAnalyticsWorkspace.bicep' = {
  name: 'devLogAnalyticsWorkspaceDeploy'
  params: {
    logAnalyticsWorkspaceName: devLogAnalyticsWorkspaceName
    logAnalyticsWorkspaceSku: devLogAnalyticsWorkspaceSku
    location: location
    retentionInDays: devRetentionInDays
  }
}

module stageLogAnalyticsWorkspace './modules/logAnalyticsWorkspace.bicep' = {
  name: 'stageLogAnalyticsWorkspaceDeploy'
  params: {
    logAnalyticsWorkspaceName: stageLogAnalyticsWorkspaceName
    logAnalyticsWorkspaceSku: logAnalyticsWorkspaceSku
    location: location
    retentionInDays: retentionInDays
  }
}

module prodLogAnalyticsWorkspace './modules/logAnalyticsWorkspace.bicep' = {
  name: 'prodLogAnalyticsWorkspaceDeploy'
  params: {
    logAnalyticsWorkspaceName: prodLogAnalyticsWorkspaceName
    logAnalyticsWorkspaceSku: logAnalyticsWorkspaceSku
    location: location
    retentionInDays: retentionInDays
  }
}

module devStorageAccount 'modules/storageAccount.bicep' = {
  name: '${devPrefix}storageAccountDeploy'
  params: {
    storageAccountName: devStorageAccountName
    storageAccountSku: devStorageAccountSku
    fileShareFolderName: devGhostContentFileShareName
    logAnalyticsWorkspaceId: devLogAnalyticsWorkspace.outputs.id
    location: location
  }
}

// dev storageAccount
module stageStorageAccount 'modules/storageAccount.bicep' = {
  name: '${stagePrefix}storageAccountDeploy'
  params: {
    storageAccountName: stageStorageAccountName
    storageAccountSku: storageAccountSku
    fileShareFolderName: stageGhostContentFileShareName
    logAnalyticsWorkspaceId: stageLogAnalyticsWorkspace.outputs.id
    location: location
  }
}

module prodStorageAccount 'modules/storageAccount.bicep' = {
  name: '${prodPrefix}storageAccountDeploy'
  params: {
    storageAccountName: prodStorageAccountName
    storageAccountSku: storageAccountSku
    fileShareFolderName: prodGhostContentFileShareName
    logAnalyticsWorkspaceId: prodLogAnalyticsWorkspace.outputs.id
    location: location
  }
}

// dev keyVault
module devKeyVault './modules/keyVault.bicep' = {
  name: '${devPrefix}keyVaultDeploy'
  params: {
    keyVaultName: devKeyVaultName
    keyVaultSecretName: 'databasePassword'
    keyVaultSecretValue: devDatabasePassword
    logAnalyticsWorkspaceId: devLogAnalyticsWorkspace.outputs.id
    servicePrincipalId: devWebApp.outputs.principalId
    location: location
  }
}

module stageKeyVault './modules/keyVault.bicep' = {
  name: '${stagePrefix}KeyVaultDeploy'
  params: {
    keyVaultName: stageKeyVaultName
    keyVaultSecretName: 'databasePassword'
    keyVaultSecretValue: stageDatabasePassword
    logAnalyticsWorkspaceId: stageLogAnalyticsWorkspace.outputs.id
    servicePrincipalId: stageWebApp.outputs.principalId
    location: location
  }
}

module prodKeyVault './modules/keyVault.bicep' = {
  name: '${prodPrefix}KeyVaultDeploy'
  params: {
    keyVaultName: prodKeyVaultName
    keyVaultSecretName: 'databasePassword'
    keyVaultSecretValue: prodDatabasePassword
    logAnalyticsWorkspaceId: prodLogAnalyticsWorkspace.outputs.id
    servicePrincipalId: prodWebApp.outputs.principalId
    location: location
  }
}

// devWebApp
module devWebApp './modules/webApp.bicep' = {
  name: '${devPrefix}webAppDeploy'
  params: {
    containerRegistryUrl: containerRegistryUrl
    webAppName: devWebAppName
    appServicePlanId: devAppServicePlan.outputs.id
    ghostContainerImage: ghostContainerName
    ghostContainerTag: devGhostContainerTag
    storageAccountName: devStorageAccount.outputs.name
    storageAccountAccessKey: devStorageAccount.outputs.accessKey
    fileShareName: devGhostContentFileShareName
    containerMountPath: ghostContentFilesMountPath
    location: location
    logAnalyticsWorkspaceId: devLogAnalyticsWorkspace.outputs.id
    deploymentConfiguration: devDeploymentConfiguration
    useWarmUpSlots: true
  }
}

module stageWebApp './modules/webApp.bicep' = {
  name: '${stagePrefix}WebAppDeploy'
  params: {
    containerRegistryUrl: containerRegistryUrl
    webAppName: stageWebAppName
    appServicePlanId: stageAppServicePlan.outputs.id
    ghostContainerImage: ghostContainerName
    ghostContainerTag: stageGhostContainerTag
    storageAccountName: stageStorageAccount.outputs.name
    storageAccountAccessKey: stageStorageAccount.outputs.accessKey
    fileShareName: stageGhostContentFileShareName
    containerMountPath: ghostContentFilesMountPath
    location: location
    logAnalyticsWorkspaceId: stageLogAnalyticsWorkspace.outputs.id
    deploymentConfiguration: stageDeploymentConfiguration
    useWarmUpSlots: true
  }
}

module prodWebApp './modules/webApp.bicep' = {
  name: '${prodPrefix}WebAppDeploy'
  params: {
    containerRegistryUrl: containerRegistryUrl
    webAppName: prodWebAppName
    appServicePlanId: prodAppServicePlan.outputs.id
    ghostContainerImage: ghostContainerName
    ghostContainerTag: prodGhostContainerTag
    storageAccountName: prodStorageAccount.outputs.name
    storageAccountAccessKey: prodStorageAccount.outputs.accessKey
    fileShareName: prodGhostContentFileShareName
    containerMountPath: ghostContentFilesMountPath
    location: location
    logAnalyticsWorkspaceId: prodLogAnalyticsWorkspace.outputs.id
    deploymentConfiguration: prodDeploymentConfiguration
    useWarmUpSlots: true
  }
}

module prodWarmUpSlot './modules/deploymentSlot.bicep' = {
  name: '${prodPrefix}WebAppDeploy'
  params: {
    containerRegistryUrl: containerRegistryUrl
    webAppName: prodWebAppName
    appServicePlanId: prodAppServicePlan.outputs.id
    ghostContainerImage: ghostContainerName
    ghostContainerTag: prodGhostContainerTag
    location: location
    warmUpSlotName: warmUpSlotName
  }
}

// devFunction
module devFunction './modules/function.bicep' = {
  name: '${devPrefix}functionDeploy'
  params: {
    pkgURL: devPkgURL
    functionName: devFunctionName
    appServicePlanId: devAppServicePlan.outputs.id
    location: location
    applicationInsightsNameFunction: devApplicationInsightsNameFunction
    ghostApiVersion: devGhostApiVersion
    ghostURL: 'http://test'
    storageAccountAccessKey: devStorageAccount.outputs.accessKey
    storageAccountName: devStorageAccount.outputs.name
  }
}

module stagefunction './modules/function.bicep' = {
  name: '${stagePrefix}functionDeploy'
  params: {
    pkgURL: stagePkgURL
    functionName: stageFunctionName
    appServicePlanId: stageAppServicePlan.outputs.id
    location: location
    applicationInsightsNameFunction: stageApplicationInsightsNameFunction
    ghostApiVersion: ghostApiVersion
    ghostURL: '${http_prefix}${stageFrontDoor.outputs.frontendEndpointHostName}'
    storageAccountAccessKey: stageStorageAccount.outputs.accessKey
    storageAccountName: stageStorageAccount.outputs.name
  }
}

module prodfunction './modules/function.bicep' = {
  name: '${prodPrefix}functionDeploy'
  params: {
    pkgURL: prodPkgURL
    functionName: prodFunctionName
    appServicePlanId: prodAppServicePlan.outputs.id
    location: location
    applicationInsightsNameFunction: prodApplicationInsightsNameFunction
    ghostApiVersion: ghostApiVersion
    ghostURL: '${http_prefix}${prodFrontDoor.outputs.frontendEndpointHostName}'
    storageAccountAccessKey: prodStorageAccount.outputs.accessKey
    storageAccountName: prodStorageAccount.outputs.name
  }
}

// devWebAppSettings
module devWebAppSettings 'modules/webAppSettings.bicep' = {
  name: '${devPrefix}WebAppSettingsDeploy'
  params: {
    webAppName: devWebApp.outputs.name
    applicationInsightsConnectionString: devApplicationInsights.outputs.ConnectionString
    applicationInsightsInstrumentationKey: devApplicationInsights.outputs.InstrumentationKey
    containerRegistryUrl: containerRegistryUrl
    containerMountPath: ghostContentFilesMountPath
    databaseHostFQDN: devMySQLServer.outputs.fullyQualifiedDomainName
    databaseLogin: databaseLogin
    databasePasswordSecretUri: devKeyVault.outputs.databasePasswordSecretUri
    databaseName: databaseName
    siteUrl: 'https://${devWebApp.outputs.hostName}'
  }
}

module stagewebAppSettings 'modules/webAppSettings.bicep' = {
  name: 'stagewebAppSettingsDeploy'
  params: {
    webAppName: stageWebApp.outputs.name
    applicationInsightsConnectionString: stageApplicationInsights.outputs.ConnectionString
    applicationInsightsInstrumentationKey: stageApplicationInsights.outputs.InstrumentationKey
    containerRegistryUrl: containerRegistryUrl
    containerMountPath: ghostContentFilesMountPath
    databaseHostFQDN: stageMySQLServer.outputs.fullyQualifiedDomainName
    databaseLogin: databaseLogin
    databasePasswordSecretUri: stageKeyVault.outputs.databasePasswordSecretUri
    databaseName: databaseName
    siteUrl: stageSiteUrl
  }
}

module prodwebAppSettings 'modules/webAppSettings.bicep' = {
  name: 'prodwebAppSettingsDeploy'
  params: {
    webAppName: prodWebApp.outputs.name
    applicationInsightsConnectionString: prodApplicationInsights.outputs.ConnectionString
    applicationInsightsInstrumentationKey: prodApplicationInsights.outputs.InstrumentationKey
    containerRegistryUrl: containerRegistryUrl
    containerMountPath: ghostContentFilesMountPath
    databaseHostFQDN: prodMySQLServer.outputs.fullyQualifiedDomainName
    databaseLogin: databaseLogin
    databasePasswordSecretUri: prodKeyVault.outputs.databasePasswordSecretUri
    databaseName: databaseName
    siteUrl: prodSiteUrl
  }
}

// devAppServicePlan
module devAppServicePlan './modules/appServicePlan.bicep' = {
  name: '${devPrefix}appServicePlanDeploy'
  params: {
    appServicePlanName: devAppServicePlanName
    appServicePlanSku: devAppServicePlanSku
    location: location
    logAnalyticsWorkspaceId: devLogAnalyticsWorkspace.outputs.id
    zoneRedundant: false
  }
}

module stageAppServicePlan './modules/appServicePlan.bicep' = {
  name: '${stagePrefix}appServicePlanDeploy'
  params: {
    appServicePlanName: stageAppServicePlanName
    appServicePlanSku: appServicePlanSku
    location: location
    logAnalyticsWorkspaceId: stageLogAnalyticsWorkspace.outputs.id
    zoneRedundant: true
  }
}

module prodAppServicePlan './modules/appServicePlan.bicep' = {
  name: '${prodPrefix}appServicePlanDeploy'
  params: {
    appServicePlanName: prodAppServicePlanName
    appServicePlanSku: appServicePlanSku
    location: location
    logAnalyticsWorkspaceId: prodLogAnalyticsWorkspace.outputs.id
    zoneRedundant: true
  }
}

module stageWebAppAutoScaling './modules/webAppAutoScaling.bicep' = {
  name: '${stagePrefix}appServiceAutoScale'
  params: {
    autoScaleSettingName: stageAutoScaleSettingName
    appServicePlanId: stageAppServicePlan.outputs.id
    location: location
    scaleActionIncrease: scaleActionIncrease
    autoScaleCPUTreshold: autoScaleCPUTreshold
    autoScaleDefault: autoScaleDefault
    autoScaleMax: autoScaleMax
    autoScaleMin: autoScaleMin
  }
}

module prodWebAppAutoScaling './modules/webAppAutoScaling.bicep' = {
  name: '${prodPrefix}appServiceAutoScale'
  params: {
    autoScaleSettingName: prodAutoScaleSettingName
    appServicePlanId: prodAppServicePlan.outputs.id
    location: location
    scaleActionIncrease: scaleActionIncrease
    autoScaleCPUTreshold: autoScaleCPUTreshold
    autoScaleDefault: autoScaleDefault
    autoScaleMax: autoScaleMax
    autoScaleMin: autoScaleMin
  }
}


// devApplicationInsights
module devApplicationInsights './modules/applicationInsights.bicep' = {
  name: '${devPrefix}ApplicationInsightsDeploy'
  params: {
    applicationInsightsName: devApplicationInsightsName
    location: location
    logAnalyticsWorkspaceId: devLogAnalyticsWorkspace.outputs.id
  }
}

module stageApplicationInsights './modules/applicationInsights.bicep' = {
  name: '${stagePrefix}ApplicationInsightsDeploy'
  params: {
    applicationInsightsName: stageApplicationInsightsName
    location: location
    logAnalyticsWorkspaceId: stageLogAnalyticsWorkspace.outputs.id
  }
}

module prodApplicationInsights './modules/applicationInsights.bicep' = {
  name: '${prodPrefix}ApplicationInsightsDeploy'
  params: {
    applicationInsightsName: prodApplicationInsightsName
    location: location
    logAnalyticsWorkspaceId: prodLogAnalyticsWorkspace.outputs.id
  }
}


// devMySQLServer
module devMySQLServer 'modules/mySQLServer.bicep' = {
  name: '${devPrefix}MySQLServerDeploy'
  params: {
    administratorLogin: databaseLogin
    administratorPassword: devDatabasePassword
    location: location
    logAnalyticsWorkspaceId: devLogAnalyticsWorkspace.outputs.id
    mySQLServerName: devMySQLServerName
    mySQLServerSku: devMySQLServerSku
    geoRedundantBackup: devGeoRedundantBackup
    highAvailabilityMode: devHighAvailabilityMode
  }
}

module stageMySQLServer 'modules/mySQLServer.bicep' = {
  name: '${stagePrefix}MySQLServerDeploy'
  params: {
    administratorLogin: databaseLogin
    administratorPassword: stageDatabasePassword
    location: location
    logAnalyticsWorkspaceId: stageLogAnalyticsWorkspace.outputs.id
    mySQLServerName: stageMySQLServerName
    mySQLServerSku: mySQLServerSku
    geoRedundantBackup: geoRedundantBackup
    highAvailabilityMode: highAvailabilityMode
  }
}

module prodMySQLServer 'modules/mySQLServer.bicep' = {
  name: '${prodPrefix}MySQLServerDeploy'
  params: {
    administratorLogin: databaseLogin
    administratorPassword: prodDatabasePassword
    location: location
    logAnalyticsWorkspaceId: prodLogAnalyticsWorkspace.outputs.id
    mySQLServerName: prodMySQLServerName
    mySQLServerSku: mySQLServerSku
    geoRedundantBackup: geoRedundantBackup
    highAvailabilityMode: highAvailabilityMode
  }
}


module stageCdnEndpoint './modules/cdnEndpoint.bicep' = if (stageDeploymentConfiguration == 'Web app with Azure CDN') {
  name: 'stageCdnEndPointDeploy'
  params: {
    cdnProfileName: stageCdnProfileName
    cdnProfileSku: cdnProfileSku
    cdnEndpointName: stageCdnEndpointName
    location: location
    logAnalyticsWorkspaceId: stageLogAnalyticsWorkspace.outputs.id
    webAppName: stageWebApp.name
    webAppHostName: stageWebApp.outputs.hostName
  }
}

module prodCdnEndpoint './modules/cdnEndpoint.bicep' = if (prodDeploymentConfiguration == 'Web app with Azure CDN') {
  name: 'prodCdnEndPointDeploy'
  params: {
    cdnProfileName: prodCdnProfileName
    cdnProfileSku: cdnProfileSku
    cdnEndpointName: prodCdnEndpointName
    location: location
    logAnalyticsWorkspaceId: prodLogAnalyticsWorkspace.outputs.id
    webAppName: prodWebApp.name
    webAppHostName: prodWebApp.outputs.hostName
  }
}

module stageFrontDoor 'modules/frontDoor.bicep' = if (stageDeploymentConfiguration == 'Web app with Azure Front Door') {
  name: 'stageFrontDoorDeploy'
  params: {
    frontDoorName: stageFrontDoorName
    wafPolicyName: stageWafPolicyName
    logAnalyticsWorkspaceId: stageLogAnalyticsWorkspace.outputs.id
    webAppName: stageWebApp.outputs.name
  }
}

module prodFrontDoor 'modules/frontDoor.bicep' = if (prodDeploymentConfiguration == 'Web app with Azure Front Door') {
  name: 'prodFrontDoorDeploy'
  params: {
    frontDoorName: prodFrontDoorName
    wafPolicyName: prodWafPolicyName
    logAnalyticsWorkspaceId: prodLogAnalyticsWorkspace.outputs.id
    webAppName: prodWebApp.outputs.name
  }
}

output devWebAppName string = devWebApp.outputs.name
output stageWebAppName string = stageWebApp.outputs.name
output prodWebAppName string = prodWebApp.outputs.name
output devWebAppPrincipalId string = devWebApp.outputs.principalId
output stageWebAppPrincipalId string = stageWebApp.outputs.principalId
output prodWebAppPrincipalId string = prodWebApp.outputs.principalId
output devWebAppHostName string = devWebApp.outputs.hostName
output stageWebAppHostName string = stageWebApp.outputs.hostName
output prodWebAppHostName string = prodWebApp.outputs.hostName


var stageEndpointHostName = (stageDeploymentConfiguration == 'Web app with Azure Front Door') ? stageFrontDoor.outputs.frontendEndpointHostName : stageCdnEndpoint.outputs.cdnEndpointHostName

output stageEndpointHostName string = stageEndpointHostName

// TODO
// var endpointHostName = (deploymentConfiguration == 'Web app with Azure Front Door') ? frontDoor.outputs.frontendEndpointHostName : cdnEndpoint.outputs.cdnEndpointHostName

// output endpointHostName string = endpointHostName



