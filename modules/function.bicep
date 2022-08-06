
@allowed([
  'v4.0'
  'v5.0'
])
param ghostApiVersion string

param ghostURL string 

@minLength(2)
@maxLength(60)
param functionName string

@description('Location to deploy the resources')
param location string = resourceGroup().location

@description('App Service Plan id to host the app')
param appServicePlanId string

// @description('Log Analytics workspace id to use for diagnostics settings')
// param logAnalyticsWorkspaceId string

@description('Name of Application Insights resource.')
param applicationInsightsNameFunction string

param pkgURL string

param storageAccountAccessKey string

param storageAccountName string

resource functionApp 'Microsoft.Web/sites@2021-03-01' = {
  name: functionName
  location: location
  kind: 'functionapp,linux'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlanId
    siteConfig: {
      appSettings: [
        {
          name: 'GHOST_URL'
          value: ghostURL
        }
        {
          name: 'GHOST_API_VERSION'
          value: ghostApiVersion
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccountAccessKey}'

        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: applicationInsightsFunction.properties.InstrumentationKey
        }
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: pkgURL
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '~16'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'node'
        }
      ]
      linuxFxVersion: 'Node|16'
      minTlsVersion: '1.2'
      alwaysOn: true
      http20Enabled: false
    } 
    redundancyMode: 'None'
    storageAccountRequired: false
    keyVaultReferenceIdentity: 'SystemAssigned'
    httpsOnly: true
  }
}    




resource applicationInsightsFunction 'Microsoft.Insights/components@2020-02-02' = {
  name: applicationInsightsNameFunction
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Request_Source: 'rest'
  }
}





