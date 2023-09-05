# Cardiff Serverless Days Azure Workshop 2023

A sample Todo app built with Vue.js that uses Azure Static Web Apps, Data API builder and Azure SQL Database.

The Todo application allows to

- Create either public or private todos 
- Update or delete todos
- Mark a todo as completed
- Drag and drop to reorder todos

it uses the following features

- Backend REST API via Data API builder 
- Authentication via Easy Auth configured to use GitHub
- Authorization via Data API builder policies
- Data API builder hosted in Azure via Static Web Apps "Database Connections"

## Pre-Requisites 

- Visual Studio Code or Prefered IDE

- An Azure Subscription with Contributor Privileges

- A GitHub Account

- AZ CLI installed locally.

If you do not have the AZ CLI installed this can be done quickly here: https://learn.microsoft.com/en-us/cli/azure/install-azure-cli

# Workshop

## 1. Setup GitHub Repository 

To start with for this workshop you will need to fork this repository. This can be done from the root of this repository.

<img width="1168" alt="FORK" src="https://github.com/owainow/cardiff-serverless-days-workshop/assets/48108258/111a2a58-fe54-433d-9674-4e29251dede8">



Once this repository is forked you will have your own version of the repository. This will allow us to push our own code changes. 


## 2. Create the static web app resource.

To start with we will need to login to our Azure Account. For this we will use the Azure CLI. We will use the interactive portal to login using the following command:

```shell
az login
```
Once we have logged in we can start to create our Azure Resources.

To start with we need to create a resource group. We can do that with the following command:

```shell
az group create -n cardiff-serverless-days -l uksouth
```
We can then create a new Static Web App with the following command: 

```shell
az staticwebapp create -n cardiff-serverless-days-webapp -g cardiff-serverless-days
```

Once it is provisioned we then need to get the Static Web App deployment token:


```shell
az staticwebapp secrets list --name cardiff-serverless-days-webapp -g cardiff-serverless-days --query "properties.apiKey" -o tsv
```

Take note of that token as we will need it later for our GitHub Actions. 

## 3. Create and configure the Azure SQL Database

We can create a new Azure SQL server using the following command:

```shell
az sql server create -n cardiff-serverless-days-db -g cardiff-serverless-days -l uksouth --admin-user cardiffserverless --admin-password C@rdiffS3rv3rless2023
```
We can then set our signed in user as the AD Admin. To do this we will require our user object id:

```shell
az ad signed-in-user show --query id -o tsv
```


Then create the AD Admin for our server.

```shell
az sql server ad-admin create --display-name <yourfirstname> --object-id <id> --server cardiff-serverless-days-db -g cardiff-serverless-days
```

We now need to ensure that Azure Services can connect to the created Azure SQL server:

```shell
az sql server firewall-rule create -n AllowAllWindowsAzureIps -g cardiff-serverless-days --server cardiff-serverless-days-db --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0
```

This is an open firewall rule and certainly not advisable outside of the context of this workshop. To learn more  about how to configure an Azure SQL firewall click here: [Connections from inside Azure](https://learn.microsoft.com/azure/azure-sql/database/firewall-configure?view=azuresql#connections-from-inside-azure)



## 4. Create the GitHub Secrets

Before we trigger our pipeline we will need to update our secrets to correspond with the values created in this setup. 

The first thing we need to do is create a service principal that has contributor privileges to either our subscription or resource group. We can do this with the following command.

```shell 
az ad sp create-for-rbac -n serverless-days-cardiff-2023-sp --skip-assignment
```

```shell 
az role assignment create --assignee <SP ID>  --role Contributor --scope /subscriptions/<Subscription_ID>/resourceGroups/cardiff-serverless-days
```

We can then create 3 GitHub Actions with the output from the first command. The following secrets can be created by going into your GitHub repository settings, selecting Secrets & Variables > Actions > New Repository Secret.

We need to create the following individual secrets for use in our deployment pipeline:

`AZURE_CLIENT_ID : appId`
`AZURE_CLIENT_SECRET : password`
`AZURE_TENANT_ID : tenat`

We can also then create our Azure subscription secret by copying the subscription ID from the Azure Portal.

`SUBSCRIPTION_ID : Subscription ID`

We finally need to create two secrets from our earlier commands. The first is the "AZURE_STATIC_WEB_APPS_API_TOKEN" which you should have noted down earlier.

`AZURE_STATIC_WEB_APPS_API_TOKEN : API Token value`

And then we need to retrive our SQL Connection string. We can do that with the following (don't worry if the TodoDB database doesn't exist yet, it will be created later automatically):

```shell 
az sql db show-connection-string -s cardiff-serverless-days-db -n TodoDB -c ado.net
```

You will then need to replace the `<username>` and `<password>` in the connection string with those for a user that can perform DDL (create/alter/drop) operations on the database. We will use the admin details that we created earlier at the point we created the database

If you are following the tutorial names this will be cardiffserverless & C@rdiffS3rv3rless2023.

`AZURE_SQL_CONNECTION_STRING : Custom SQL connection string value`

## 5. Run the pipeline

The first time we trigger this pipeline we will use a manual trigger. To do this we will head to the Actions section at the top of the page. Then we will click on our Azure Static Web Apps workflow which has been created already and then click "Run Workflow". We can monitor the progress of the workflow by clicking into the running workflow and viewing the steps. 

## 6. View the Application

Once the workflow has completed we can head to our Azure Portal and view the deployment. Type "Static Web Apps" in the search bar and select the static web app. You should see a SWA called "cardiff-serverless-days-webapp". Once you click through you should be able to see the public URL. Click on the URL and add a new todo to the list. We can see we now have a fully functioning static web app. Below the app is also login capabilites using GitHub as the IDP allowing you to create a persisted todo list. 

## 7. New application feature

Let's now see how we can utilise the Data API builder to minimise the code required to make a change to this application. Let us now add an additional collumn to the application such as "Due Date".

To start with we will need to create a new branch for our feature change. To do this we can use the following command: 

```shell 
git checkout -b duedate
```

We can then publish the branch in our remote repository with the following command: 

```shell 
git push -u origin duedate
```

We now need to make our first branch specific code change. We need to change our GitHub Action to be triggered by the new branch. Within our GitHub Action manifest we need to add the following to our triggers:

```yaml
on:
  workflow_dispatch:    
  push:
    branches:
      - main
      - duedate
  pull_request:
    types: [opened, synchronize, reopened, closed]
    branches:
      - main
      - duedate
```

Once we have made this chance to our local files we can then save it, commit and push it to our branch. 