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

![Decompile into bicep in the explorer sidebar](./images/decompileSidebar.png)

## Creating a template in the portal

It is also possible to create a base template in the Azure portal _without_ creating the actual resource. The process is similar to `Using Azure portal export`, yet requires a couple of extra steps.

1. In the [Azure portal](https://portal.azure.com), click `Create a resource`
2. Search the marketplace for `storage account`and select `Create` on the `Storage account` app from Microsoft.
3. Use the settings from `Creating a storage account in Azure`, but after `Validation`, do _NOT_ click the `Create` button. Instead, click the `Download a template for automation` link.
4. In the `template` window, click `Download`
5. Continue from step 4 in `Using Azure portal export` - "Extract the downloaded zip file"

## Cleaning up an exported or created resource

While exporting resources is a great way to start, In many cases you get a lot more in your templates than needed. The configurations may also not always be as flexible or reusable as you want them.

This lab will look at some ways to simplify your templates and make them easier to reuse.

You can find the initial templates, and the end results, in the subfolder named `templates`

### General clean-up

Lots of the data you get from an exported template is actually the default values of properties, and not necessary to set unless you want to change those values.

Finding allowed and default values can be done in multiple ways, and there will be many keys and values to remove outside of the two examples provided. Try to clean as much as possible before looking at the result template.

#### Using the documentation

1. Hover your mouse over the _name_ of the resource you're interested in to get help on.
2. Click the `View Type Documentation` link to open the online documentation in your default browser.

![View type documentation from the VSCode plugin](./images/hoverViewTypeDocumentation.png)

> Hint: Make sure the `Bicep` button is highlighted in the `Choose a deployment language` box to get the correct help documentation.

In [the documentation for the storage account resource type](https://learn.microsoft.com/en-gb/azure/templates/microsoft.storage/storageaccounts?tabs=bicep&pivots=deployment-language-bicep#storageaccountpropertiescreateparametersorstorageaccountproperties) we can see that the value for `allowBlobPublicAccess` is default set to `true`. Since the value in our template is the same, and this is not a mandatory parameter we can remove this setting completely.

We can also see that the `Sku` array contains a `tier` key, but [no such key is listed in the documentation](https://learn.microsoft.com/en-gb/azure/templates/microsoft.storage/storageaccounts?tabs=bicep&pivots=deployment-language-bicep#sku). Hovering over the _yellow squiggly_ line tells us that this is a read only property and we can safely remove it.

![squiggly giving a hint that this property should be verified before deploy](./images/hoverTierPropertyIssue.png)

#### Using VSCode built in documentation

You can in many cases also get property information by using the built in VSCode functionality.

- Hovering over the `SupportsHTTPSTrafficOnly` key gives us the same information [found in the documentation](https://learn.microsoft.com/en-gb/azure/templates/microsoft.storage/storageaccounts?tabs=bicep&pivots=deployment-language-bicep#storageaccountpropertiescreateparametersorstorageaccountproperties). Since we are working with API version `2022-05-01` we can safely remove this setting.

![Hovering show us the default is true](./images/hoverHTTPSTraffic.png)

### Using parameters

In order to make the template easier to reuse there are some values that the export hard coded that you will want to have as parameters.

One such example is the `Location` parameter.

![Hovering over the _yellow squiggly_ will tell you this should be a parameter](./images/hoverLocationHardcoded.png)

In the hover window, click the `Quick Fix...` button to automatically create a parameter and set the values correct.

In our template we have one container set up. The export hard coded this container name as `mycontainer`, but in order to make the template reusable we will want the end user to set this.

1. Create a parameter in the top of the bicep file - `param containerName string`

2. Replace the value of the name key with the parameter - `name: containerName`

3. Since no default value is given to this parameter, add it as a parameter with a default value in the parameters file.

### Using Variables

When deploying templates we often construct properties based on input. For example we may want to use [Azure naming conventions](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-general) based on the name parameter.

1. Add a parameter called `baseName` as a required parameter. For ease of use, give it a good description using the `@description` decorator. Remember to add it to the parameter file as well.
2. Add a variable called `saName` following the [storage account naming convention](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-storage) using string interpolation.
3. Change the storage account to use the variable instead of a parameter
4. Remove the now unused parameter from the template and the parameter file.

```Bicep
// Only changed or added values are displayed here
@description('This name will be the base of which all other resources will be calculated')
param baseName string
// ----
var saName = 'sa${baseName}'
// ----
name: saName
// ----
```

### Using Functions

## Creating a sub resource by using the Azure portal template creator