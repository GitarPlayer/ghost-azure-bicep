
targetScope = 'resourceGroup'

param appServicePlanId string

param autoScaleSettingName string

@description('Location to deploy the resources')
param location string = resourceGroup().location

param autoScaleMin string
param autoScaleMax string
param autoScaleDefault string
param autoScaleCPUTreshold int 
param scaleActionIncrease string



resource autoScaleSetting 'Microsoft.Insights/autoscalesettings@2015-04-01' = {
  name: autoScaleSettingName
  location: location
  tags: {
  }
  properties: {
    profiles: [
      {
        name: 'Auto created scale condition'
        capacity: {
          minimum: autoScaleMin
          maximum: autoScaleMax
          default: autoScaleDefault
        }
        rules: [
          {
            metricTrigger: {
              metricName: 'CpuPercentage'
              metricNamespace: 'microsoft.web/serverfarms'
              metricResourceUri: appServicePlanId
              timeGrain: 'PT1M'
              statistic: 'Average'
              timeWindow: 'PT5M'
              timeAggregation: 'Average'
              operator: 'GreaterThan'
              threshold: autoScaleCPUTreshold
              dimensions: []
              dividePerInstance: false
            }
            scaleAction: {
              direction: 'Increase'
              type: 'ChangeCount'
              value: scaleActionIncrease
              cooldown: 'PT10M'
            }
          }
        ]
      }
    ]
    enabled: true
    name: autoScaleSettingName
    targetResourceUri: appServicePlanId
    notifications: []
  }
}
