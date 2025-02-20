@description('The name of the Azure AI Search service')
var aiSearchName  = 'aisearch'

// Product Updates I am happy to announce that Semantic search (preview) is now available in the following regions:
// Australia Southeast
// Brazil South 
// Canada East              
// Central India            
// East Asia                
// France Central           
// Jio India West          
// Korea Central           
// West Central US         
// West US 3               
// Korea South             
// Switzerland North       
// Switzerland West        
// UK West
// [NEW] Japan East 
// [NEW] Japan West 
// [NEW] Qatar Central 


@description('A prefix that will be prepended to resource names')
param namePrefix string = 'dev'

@description('The region for the Azure AI Search service')
param aiSearchRegion string = 'eastus'

@description('A unique identifier that will be appended to resource names')
param uniqueid string

var varaiSearchName = '${namePrefix}${aiSearchName}${uniqueid}'

resource searchService 'Microsoft.Search/searchServices@2023-11-01' = {
  name: varaiSearchName
  location: aiSearchRegion
  sku: {
    name: 'basic'
  }
  properties: {
    replicaCount: 1
    partitionCount: 1
    hostingMode: 'default'
    publicNetworkAccess: 'enabled' // Enable public network access
    networkRuleSet: {
      ipRules: []
    }
    encryptionWithCmk: {
      enforcement: 'Unspecified'
    }
    disableLocalAuth: false
    authOptions: {
      apiKeyOnly: {}
    }
    semanticSearch: 'standard'
  }
}

output aiSearchName string = varaiSearchName
output aiSearchEndpoint string = 'https://${varaiSearchName}.search.windows.net'
#disable-next-line outputs-should-not-contain-secrets
output aiSearchAdminKey string = searchService.listAdminKeys().primaryKey
