# Exporting resources

There are many different ways to get started creating bicep templates.
In this lab we will look at different ways to use the Azure portal to help us create a bicep resource.

In order to do this we will need access to an Azure account with a connected subscription. If you do not have one you can sign up for a free evaluation account with 200$ credit [here](https://azure.microsoft.com/en-us/free/)

## Creating a storage account in Azure

In many cases you will already have a resource similar to the one you created in your Azure environment. Maybe you lift and shifted a server room, or you used to portal to test your design. In this lab we will simulate this scenario by first creating an Azure storage account in our Azure subscription.

> Note: The recommended settings here are _NOT_ for production use. The setup is primarily for easy access and low cost lab. Production workloads may require higher levels of security, faster access, and better redundancy.

1. Log in to Azure
2. Select `Create a resource`
3. In the marketplace, search for `Storage account`, and select the `storage account`resource by Microsoft from the list
4. Click `Create`
5. Recommended settings for our lab are
  - Basics
    - Create a new resource group
    - Choose a region close to you, for example 'West Europe' or 'Sweden Central'
    - Performance: Standard
    - Redundancy: Locally-redundant storage (LRS)
  - Advanced
    - Require secure transfer for REST API operations
    - Access tier: Hot
  - Networking
    - Network access: Enable public access from all networks
  - Data protection
    - Uncheck all soft delete checkboxes.
6. Click `Create`

## Exporting the resource to Visual Studio Code

Once you have a resource set up in Azure there are a number of ways of retrieving it to your bicep template.

### Using the VSCode bicep extension

> **NOTE:** At the time of this writing there is [a bug in the VSCode extension](https://github.com/Azure/bicep/issues/9241) that causes this to not work in some cases. If this case doesn't work, please continue to the next lab.

The bicep extension for VSCode includes the `Insert resource` command. You can use this to directly export a resource from your Azure environment to your VSCode session.

To do this you need to know the resource id of the resource you want to export. You can get this id through the portal, using Azure PowerShell, or as described here, using the az cli

1. If not already open, open the console in VSCode by clicking `Ctrl+ö`, or `View -> terminal`
2. Run the command `az login` to connect to your azure subscription
3. Run the command `az resource show --resource-type "Microsoft.Storage/storageAccounts" -g "<your resource group>" -n "<Name of your storage account>" --query 'id'`

> Tip: you can pipe the output of this command directly to your clip board by adding "`| clip`" to the end of the command on windows.

Once you have found the id of your resource you can insert it to your VSCode session.

1. Open the Command palette in VSCode as described in [lab number 1](../1.%20Setting%20up%20your%20resources/lab.md)
2. in the search window, type `Insert resource`
3. Paste, or type, the resource id of the resource to import _without quotation marks_

> **Note:** The bicep extension uses a strict order of account credentials to authenticate to Azure. If you have problems authenticating to azure try closing and re-opening VSCode, and _only_ authenticate using `az login` (not Azure PowerShell or the Azure.Account extension)

### Using Azure portal export

Another way of exporting a template is the export functionality in Azure.

1. Find your resource blade in the [Azure portal](https://portal.azure.com)
2. In the left menu tree under the `Automation` headline, go to `Export template`
3. Click the `Download` button to save a zip file containing your template and parameters file to your computer
4. Extract the downloaded zip file

![Downloading a template from the Azure portal](./images/exportTemplate.png)

Start working with your template in VSCode
1. Open a new VSCode window by clicking `File -> New window`
2. Open your downloaded template folder by clicking `File -> Open folder`, browse to, and select your folder.
3. In the explorer sidebar, right click `template.json` and select `Decompile into Bicep`. This will add a new file to your folder named `template.bicep`

> **Note:** If no explorer sidebar is visible, you can open it by clicking the icon with two pages seen below, or click `View -> Explorer`, Or `Ctrl+Shift+E`

![Decmpile to bicep in the explorer sidebar](./images/decompileSidebar.png)

## Creating a template in the portal

## Cleaning up an exported resource

### Using parameters

### Using Variables

### Using Functions

## Creating a sub resource by using the Azure portal template creator