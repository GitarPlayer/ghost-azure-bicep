targetScope = 'resourceGroup'

@description('Log Analytics workspace name')
@minLength(4)
@maxLength(64)
param logAnalyticsWorkspaceName string
var solutionName = 'SecurityInsights(${logAnalyticsWorkspace.name})'

@minValue(30)
@maxValue(730)
param retentionInDays int = 90

@description('Log Analytics workspace pricing tier')
@allowed([
  'Free'
  'LACluster'
  'PerGB2018'
  'PerNode'
  'Premium'
  'Standalone'
  'Standard'
])
param logAnalyticsWorkspaceSku string

@description('Location to deploy the resources')
param location string = resourceGroup().location

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  properties: {
    sku: {
      name: logAnalyticsWorkspaceSku
    }
    retentionInDays: retentionInDays
  }
}

resource sentinelSolution 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' = {
  name: solutionName
  location: location
  properties: {
    workspaceResourceId: logAnalyticsWorkspace.id
  }
  plan: {
    name: solutionName
    publisher: 'Microsoft'
    product: 'OMSGallery/SecurityInsights'
    promotionCode: ''
  }
}

output id string = logAnalyticsWorkspace.id


