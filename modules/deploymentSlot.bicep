targetScope = 'resourceGroup'

param webAppName string

@description('Location to deploy the resources')
param location string = resourceGroup().location

@description('App Service Plan id to host the app')
param appServicePlanId string

@description('Ghost container full image name')
param ghostContainerImage string

@description('Ghost container tag')
param ghostContainerTag string

param containerRegistryUrl string

param warmUpSlotName string = ''

resource existingWebApp 'Microsoft.Web/sites@2021-01-15' existing = {
  name: webAppName
}





resource WarmUpSlot 'Microsoft.Web/sites/slots@2021-03-01' = {
  parent: existingWebApp
  name: warmUpSlotName
  kind: 'app,linux,container'
  location: location
  properties: {
    enabled: true
    siteConfig: {
      appSettings: [
        {
          name: 'DOCKER_ENABLE_CI'
          value: 'true'
        }
        {
          name: 'DOCKER_CUSTOM_IMAGE_NAME'
          value: '${ghostContainerImage}:${ghostContainerTag}'
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_URL'
          value: containerRegistryUrl
        }
        {
          name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
          value: 'false'
        } 
      ]
    }
    serverFarmId: appServicePlanId
    reserved: true
    httpsOnly: true
    storageAccountRequired: false
    keyVaultReferenceIdentity: 'SystemAssigned'
  }
}









