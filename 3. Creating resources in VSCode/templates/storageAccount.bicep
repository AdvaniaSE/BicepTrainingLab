param name string

param location string = resourceGroup().location

resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: name
  location: location
  kind: 'StorageV2'
  sku: { 
    name: 'Standard_LRS' 
  }
  properties: {
    minimumTlsVersion: 'TLS1_2'
  }
}

resource myBlobService 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' = {
  name: 'default'
  parent: storageaccount
}

resource myblobContainerService 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  name: 'default'
  parent: myBlobService
}
