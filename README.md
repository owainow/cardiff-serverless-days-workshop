# Cardiff Serverless Days Azure Workshop 2023

A sample Todo app built with Vue.js that uses Azure Static Web Apps, Data API builder, and Azure SQL Database.

The Todo application allows you to

- Create either public or private todos 
- Update or delete todos
- Mark a todo as completed
- Drag and drop to reorder todos

It uses the following features:

- Backend REST API via Data API builder 
- Authentication via Easy Auth configured to use GitHub
- Authorization via Data API builder policies
- Data API builder hosted in Azure via Static Web Apps "Database Connections"

## Pre-Requisites 

- Visual Studio Code or Prefered IDE
- An Azure Subscription with Contributor Privileges
- A GitHub Account
- AZ CLI [installed locally](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) or use the cloud shell in the [Azure Portal](https://portal.azure.com)
- The Azure Static Web Apps VS Code extension
 

# Workshop

## 1. Setup GitHub Repository 

To start with for this workshop you will need to fork this repository. This can be done from the root of this repository.

<img width="1168" alt="FORK" src="https://github.com/owainow/cardiff-serverless-days-workshop/assets/48108258/111a2a58-fe54-433d-9674-4e29251dede8">



Once this repository is forked you will have your own version of the repository. This will allow us to push our own code changes. 

We can now clone our repository onto our local machine for changes we'll make later. Ensure you are logged in to Git in your IDE and open the terminal to run "Git clone <Your fork>".


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

We can create a new Azure SQL server using the following command (make sure to change `<rng>` to avoid naming collisions):

```shell
az sql server create -n cardiff-serverless-days-db<rng> -g cardiff-serverless-days -l uksouth --admin-user cardiffserverless --admin-password CardiffS3rv3rless2023
```
We can then set our signed in user as the AD Admin. To do this we will require our user object id:

```shell
az ad signed-in-user show --query id -o tsv
```


Then create the AD Admin for our server.

```shell
az sql server ad-admin create --display-name <yourfirstname> --object-id <id> --server cardiff-serverless-days-db<rng> -g cardiff-serverless-days
```

We now need to ensure that Azure Services can connect to the created Azure SQL server:

```shell
az sql server firewall-rule create -n AllowAllWindowsAzureIps -g cardiff-serverless-days --server cardiff-serverless-days-db<rng> --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0
```

This is an open firewall rule and certainly not advisable outside of the context of this workshop. To learn more about how to configure an Azure SQL firewall click here: [Connections from inside Azure](https://learn.microsoft.com/azure/azure-sql/database/firewall-configure?view=azuresql#connections-from-inside-azure)



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
az sql db show-connection-string -s cardiff-serverless-days-db<rng> -n TodoDB -c ado.net
```

You will then need to replace the `<username>` and `<password>` in the connection string with those for a user that can perform DDL (create/alter/drop) operations on the database. We will use the admin details that we created earlier at the point we created the database.

Be sure to remove the quotation marks from the connection string before adding to your GitHub Secret.

If you are following the tutorial names this will be cardiffserverless & CardiffS3rv3rless2023.

`AZURE_SQL_CONNECTION_STRING : Custom SQL connection string value`

## 5. Run the pipeline

The first time we trigger this pipeline we will use a manual trigger. To do this we will head to the Actions section at the top of the page. Then we will click on our Azure Static Web Apps workflow which has been created already and then click "Run Workflow". We can monitor the progress of the workflow by clicking into the running workflow and viewing the steps. 
<img width="587" alt="image" src="https://github.com/owainow/cardiff-serverless-days-workshop/assets/48108258/c58a137e-2906-41be-ad71-af55c2b41fed">


## 6. Configure the Static Web App Database Connection

Once the deployment has completed, navigate to the Static Web App resource in the Azure Portal and click on the [Database connection](https://learn.microsoft.com/azure/static-web-apps/database-azure-sql?tabs=bash&pivots=static-web-apps-rest) item under *Settings*. Click on *Link existing database* to connect to the Azure SQL server and the TodoDB that was created by the deployment.

You can use the sample application user that is created during the [database deployment phase](./database/TodoDB/Script.PostDeployment.sql):

- User: `todo_dab_user`
- Password: `rANd0m_PAzzw0rd!`

## 7. View the Application

Once the workflow has completed we can head to our Azure Portal and view the deployment. Type "Static Web Apps" in the search bar and select the static web app. You should see a SWA called "cardiff-serverless-days-webapp". Once you click through you should be able to see the public URL. Click on the URL and add a new todo to the list. We can see we now have a fully functioning static web app. Below the app is also login capabilites using GitHub as the IDP allowing you to create a persisted todo list. 

## 8. New application feature

Let's now see how we can utilise the Data API builder to minimise the code required to make a change to this application. Let's now update the application to add a button and corresponding collumn to our database to show items that are in progress.

To start with we will need to create a new branch for our feature change. To do this we can use the following command: 

```shell 
git checkout -b inprogress
```

We can then publish the branch in our remote repository with the following command: 

```shell 
git push -u origin inprogress
```

We now need to make our first branch specific code change. We need to change our GitHub Action to be triggered by the new branch. Within our GitHub Action manifest we need to add the following to our triggers:

```yaml
on:
  workflow_dispatch:    
  push:
    branches:
      - main
      - inprogress
  pull_request:
    types: [opened, synchronize, reopened, closed]
    branches:
      - main
      - inprogress
```
<!-- not required afaik
We also need to add an additional parameter to our workflow file. This is to specify the production branch that we want to use. This means that when using a branch to build from other then the specified branch we will create "Preview" or a test enviroment. 

```yaml
        with:
          azure_static_web_apps_api_token: ${{ secrets.AZURE_STATIC_WEB_APPS_API_TOKEN }}
          repo_token: ${{ secrets.GITHUB_TOKEN }} # Used for Github integrations (i.e. PR comments)
          action: "upload"
          production_branch: "main"
```
-->
Once we have made this chance to our local files we can then save it, commit and push it to our branch. 

As we have a new enviroment we also need to go back to our database connection tab in our static web app and add the connection for our development enviroment.

We now need to make some changes to our database config and add an additional column. We can do this by editing our `database/TodoDB/dbo.todos.sql` file:

```sql
    ...
	[position] INT NULL,
	[inprogress] [bit] NOT NULL
```

We also need to add the following to set a default for the new collumn:

```sql
...
ALTER TABLE [dbo].[todos] ADD  DEFAULT ('public') FOR [owner_id]
GO
ALTER TABLE [dbo].[todos] ADD  DEFAULT ((0)) FOR [inprogress]
GO
```

We also will then need to populate our database once it is deployed. We can do this by updating the following INSERT statement in the `database/TodoDB/Script.PostDeployment.sql` file:

```sql
insert into dbo.todos 
(
    [id],
    [title],
	[completed],
	[owner_id],
	[position],
    [inprogress]
) 
values
    ('00000000-0000-0000-0000-000000000001', N'Hello world', 0, 'public', 1, 0),
    ('00000000-0000-0000-0000-000000000002', N'This is done', 1, 'public', 2, 1),
    ('00000000-0000-0000-0000-000000000003', N'And this is not done (yet!)', 0, 'public', 4, 0),
    ('00000000-0000-0000-0000-000000000004', N'This is a ☆☆☆☆☆ tool!', 0, 'public', 3, 1),
    ('00000000-0000-0000-0000-000000000005', N'Add support for sorting', 1, 'public', 5, 0)
;
```

We now need to update our front end. To do this we will go to `client/src/components/ToDoList.vue`. Note the changes include the lines above in the source files for positional reference.

First we will need to add our new inprogress feature to our class:


```vue
...
<ul class="todo-list">        
        <li v-for="todo in filteredTodos" class="todo" :key="todo.id" :class="{ inprogress: todo.inprogress, completed: todo.completed, ...

```
Then we will need to add our inprogress checkbox to the main part of our application. 

```vue
...
            <button class="destroy" @click="removeTodo(todo)"></button>
	</div>
            <input id="inprogcheck" @change="inprogressTodo(todo)"  class="inprogtoggle" type="checkbox" v-model="todo.inprogress"  /> 
            <label class="inprogicon"> &#9202 </label>
```

So that we can filter our workitems by what is in progress we also need to add the following functions:

```vue
...
  completed: function (todos) {
    return todos.filter(todo => { return todo.completed; });
  },
  inprogress: function (todos) {
  return todos.filter(todo => { return todo.inprogress; });
  }

```


```vue
...
    filteredTodos: function () { return (filters[this.visibility](this.todos)).sort(t => t.order); },

    inprogressTodos: function () { return filters["inprogress"](this.todos) },

```

Add add the filter element to our webapp:

```vue
...
        </li>
        <li>
          <a href="#/inprogress" @click="visibility = 'inprogress'"
            :class="{ selected: visibility == 'inprogress' }">In Progress</a>
        </li>
```

Finally we then need to add the inprogressTodo function so that we can make calls to the API:

```vue
...
    completeTodo: function (todo) {
      fetch(API + `/id/${todo.id}`, {
        headers: HEADERS,
        method: "PATCH",
        body: JSON.stringify({ completed: todo.completed, order: todo.order })
      });
    },

    inprogressTodo: function (todo) {
      fetch(API + `/id/${todo.id}`, {
        headers: HEADERS,
        method: "PATCH",
        body: JSON.stringify({ inprogress: todo.inprogress, order: todo.order })
      });
    },

```

If you would instead like to copy the full final with the code changes already made please copy and paste the full contents of "finalToDoList.vue" from the Client folder in your repository. 

Commit and push the edited code.

We can then test our new application feature. Using static web apps we have created our development enviroment which can be accessed by clicking on the "Enviroments" tab in your static web app and clicking browse on the development enviroment. We could also split traffic between enviroments if we wanted too.

<img width="562" alt="app" src="https://github.com/owainow/cardiff-serverless-days-workshop/assets/48108258/a4d6d8f7-1f28-48fd-960e-8be8a931db0c">

We can now test the in-progress buttons and filter and add a new todo to check our new feature is working as expected. 

Once we verify our feature is working as expected we can create a pull request to merge our feature branch into our main branch. We should then see our features in our production enviroment. 

## 8. Conclusion 

Once on the app we can test our change and see how we are able to get and filter our todo's using the API built from our database! 

## Bonus challenge - adding Azure Functions!
We can use managed Azure Functions within Azure Static Web Apps to provide additional functionality to our applications. Let's use it to create an API that supplements our application.

### Create the API using Azure Functions
Repeat the git branching process and config update for anew branch called `helloworld`.

- Use the command pallette (ctrl+shift+p)  to select the `Azure Static Web Apps: Create HTTP` action
- Select your code preference (javascript is sensible for this project and v3)
- Call the function helloworld

Otherwise, you will need to create a new function project under `api` like, consider using the Azure Functions CLI (`func init`) if you have it:
```files
├── api
│   ├── helloworld
│   │   ├── function.json
│   │   └── index.js
│   ├── host.json
│   ├── local.settings.json
│   └── package.json
```

Update the `swa-cli.config.json` file with the api information. You may need to use the `Azure Static Web Apps: Install or Update the Azure Static Web Apps CLI` action via the command pallette if you do not have the `swa` CLI. When prompted use `dab-swa-todo` as the config name and make sure the other details look correct.

```bash
swa init
```

Commit the new and updated files and push. In the portal for the SWA, you should now be able to navigate to the APIs section and see a Function App backend for the preview environment. Clicking on `(managed)` will give you a list of functions which should just include `helloworld` for now. These functions can now be used within the app.

### Use the API in your app
To do this we will go to `client/src/components/ToDoList.vue`. Note the changes include the lines above in the source files for positional reference.

Change the header to use the API response

```js
    <header class="header">
      <h1>{{ apiResponse }}</h1>
```

Add `apiResponse` to the data for the page.

```js
      userDetails: null,
      apiResponse: ""
```

Add `created()` underneath the `data()` and call the API.

```js
  created() {
   this.apiResponse = this.helloWorld('you');
  },
```
Add the helloworld function after `pluralize` in `methods`

```js
    helloWorld: function(user) {
      fetch(`/api/helloworld?name=${user}`, {
        method: "GET",
        headers: {
          "Content-Type": "application/text",
        },
      })
        .then((res) => {
          return res.text();
        })
        .then((res) => {
          this.apiResponse = res;
        })
        .catch((error) => {
          console.error(error);
        });
    },
```

Save up, commit, and push!

You can also do local testing with a combination of the `swa` and `func` CLIs if you would like to explore.

### Additional challenges
Try taking on these extra challenges depending on your skillset:
- Database folks: create a graphql endpoint for your table
  - Recommended docs include: [Quickstart: Use Data API builder with Azure SQL](https://learn.microsoft.com/en-us/azure/data-api-builder/get-started/get-started-azure-sql)
- Front-end folks: Make the helloworld call use the the userDetails from the login activity
- Backend/Infra folks: Move the Functions to a standalone resource and link the resource instead
  - Recommended docs include: [Bring your own functions to Azure Static Web Apps](https://learn.microsoft.com/en-us/azure/static-web-apps/functions-bring-your-own)
