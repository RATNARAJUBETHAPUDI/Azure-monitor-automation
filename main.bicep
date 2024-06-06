// Parameters
param location string = 'EastUs'
param resourceGroupName string = 'CatalogResourceGroup'
param automationAccountName string = 'RoboshopAutomationAccount'
param runbookName string = 'RobotRunbook'
param loganalyticsWorkspaceName string = 'RobotLogAnalyticsWorkspace'
param applicationInsightsName string = ' CatalogAppInsights'
param actionGroupName string = 'CatalogActionGroup'
param alertRuleName string = 'CPUHighAlert'

// Automation automationAccount 
resource automationAccount 'Microsoft.Automation/automationAccounts@2024-02-31' = {
    name: automationAccountName
    location: location
    properties: {
        sku: {
            name: 'free'
        }
    }
}

// Runbook 
resource runbook 'Microsoft.Automation/automationAccounts/runbook@2024-02-31' = {
    name: '${automationAccountName}/${runbookName}'
    location: location
    properties: {
        runbookType: 'PowerShell'
        logVerbose: true
        logProgress: true
        publishContentLink: {
            uri: 'https://raw.githubusercontent.com/https://github.com/RATNARAJUBETHAPUDI?tab=repositories/installUpdates.ps1'
        }
    }
    dependsOn: [
        automationAccount
    ]
}

// Log Analytics Workspace
resource logAnalytics 'Microsoft.OperationalInsights/Workspaces@2024-02-01' = {
    name: loganalyticsWorkspaceName
    location: location
    properties: {
       sku: {
        name: 'PerGB2018'
       }
    }
}

// Application CatalogAppInsights 
resource appInsights 'Microsoft.Insights/components@2024-05-01' ={
    name: applicationInsightsName
    location: location
    properties: {
        Application_Type: 'web' 'Microsoft.Insights/actionGroups@
    }
}

// Action Group 
resource actionGroup 'Microsoft.Insights/actionGroups@2024-02-31' = {
    name: actionGroupName
    location: location
    properties: {
        groupshortName: 'MAG'
        enabled: true
        emailReceivers: [
            {
                name: 'emailReceiver'
                emailAddress: 'ratnaesi008@gmail.com'
            }
        ]
    }
}

// Alert Rule 
resource alertRule 'Microsoft.Insights/metricAlerts@2024-02-31' = {
    name: alertRuleName
    location: location
    properties: {
        description: 'Alert when CPU usage is high'
        severity:3
        enabled: true
        scopes: [
            resourceId('Microsoft.Compute/virtualMachines', 'catalogvm')
        ]
        evaluationFrequency: 'PT1M'
        windowSize: 'PT5M'
        criteria: {
            allof: [
              {
                criterionType: 'StaticThresholdCriterion'
                name: 'HighCPUUsage'
                threshold: 80
                timeAggregation: 'Average'
                operator: 'GreaterThan'
                metricNamespace: 'Microsoft.Compute/virtualMachines'
                metricName: 'Percentage CPU'

              }  
            ]
        }
        actions: [
            {
              actionGroupId: actionGroup.id
            }
        ]
    }
}