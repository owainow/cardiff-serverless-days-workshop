# Cardiff Serverless Days Workshop: Learning Outcomes & Deliverables

## 1. Executive Summary & Workshop Overview

The **Cardiff Serverless Days Azure Workshop** provides a comprehensive, hands-on masterclass in constructing, provisioning, automating, and extending modern cloud-native web applications on Microsoft Azure. Centered around a full-stack **Todo application**, the workshop guides participants through the Jamstack architectural paradigm, replacing traditional bespoke CRUD application layers with declarative, database-driven APIs.

Through this workshop, developers transition from manual resource creation to automated Infrastructure-as-Code (IaC) and Continuous Integration / Continuous Deployment (CI/CD) pipelines, exploring how **Azure Static Web Apps (SWA)**, **Azure SQL Database**, **Data API builder (DAB)**, and **Azure Functions** integrate to deliver scalable, secure, and developer-friendly architectures.

```mermaid
graph TD
    Client["Frontend SPA: Vue.js + Vite"]
    Auth["Easy Auth: GitHub IDP"]
    SWA["Azure Static Web Apps (SWA) Hosting & Gateway"]
    DAB["Data API builder (DAB) / SWA Database Connections"]
    AppUser["Runtime Least-Privilege User: todo_dab_user"]
    SQL[("Azure SQL Database: TodoDB")]
    Functions["Azure Functions: /api/helloworld & BYOF"]
    CICD["GitHub Actions: Multi-Branch & PR Previews"]

    Client -->|HTTPS / REST / GraphQL| SWA
    SWA -->|GitHub OAuth Authentication| Auth
    SWA -->|DAB Engine Proxy| DAB
    DAB -->|Connects via todo_dab_user| SQL
    SWA -->|Proxies /api/*| Functions
    CICD -->|Deploy Production & Staging Previews| SWA
    CICD -->|DACPAC Deployment (DDL Admin)| SQL
```

---

## 2. Architectural Stack & Technology Matrix

The application leverages Azure serverless and managed cloud components:

| Layer / Capability | Technology & File References | Role & Responsibility |
| :--- | :--- | :--- |
| **Frontend SPA** | [Vue.js 3 + Vite](file:///home/admin_owaino_altostrat_com/.ai-sdlc/projects/cardiff-serverless-days-workshop/.worktrees/run-2026082514030770/client/package.json), [ToDoList.vue](file:///home/admin_owaino_altostrat_com/.ai-sdlc/projects/cardiff-serverless-days-workshop/.worktrees/run-2026082514030770/client/src/components/ToDoList.vue) | Responsive Single Page Application handling UI state, drag-and-drop reordering, filtering, and asynchronous HTTP calls. |
| **Hosting & Edge Gateway** | [Azure Static Web Apps (SWA)](https://learn.microsoft.com/azure/static-web-apps/) | Global edge hosting for static assets, unified routing, API reverse proxying, staging preview environments, and authentication routing. |
| **Data Layer** | [Azure SQL Database (`TodoDB`)](file:///home/admin_owaino_altostrat_com/.ai-sdlc/projects/cardiff-serverless-days-workshop/.worktrees/run-2026082514030770/database/TodoDB/TodoDB.sqlproj) | Fully managed relational database engine storing entity state across tables defined by [dbo.todos.sql](file:///home/admin_owaino_altostrat_com/.ai-sdlc/projects/cardiff-serverless-days-workshop/.worktrees/run-2026082514030770/database/TodoDB/Tables/dbo.todos.sql). |
| **API Engine** | [Data API builder (DAB)](file:///home/admin_owaino_altostrat_com/.ai-sdlc/projects/cardiff-serverless-days-workshop/.worktrees/run-2026082514030770/swa-db-connections/staticwebapp.database.config.json) | Built-in SWA Database Connections exposing zero-code REST (`/data-api/rest/*`) and GraphQL (`/data-api/graphql`) endpoints with declarative RBAC over Azure SQL. |
| **Identity & Access** | [Static Web Apps Easy Auth](https://learn.microsoft.com/azure/static-web-apps/authentication-authorization) | Turnkey authentication utilizing GitHub as Identity Provider (IDP), passing client identity and roles to the frontend and Data API builder. |
| **Serverless Extensibility** | [Azure Functions (Managed & BYOF)](https://learn.microsoft.com/azure/azure-functions/) | Managed `/api/helloworld` HTTP function and Bring-Your-Own-Functions (`BYOF`) standalone execution for custom computational or integration logic. |
| **CI/CD & Automation** | [GitHub Actions Workflows](file:///home/admin_owaino_altostrat_com/.ai-sdlc/projects/cardiff-serverless-days-workshop/.worktrees/run-2026082514030770/.github/workflows/) | Automated pipelines managing SQL Server DACPAC schema deployments and SWA production / pull-request preview builds. |

---

## 3. Detailed Learning Outcomes by Module

### 3.1 Module 1: Serverless Full-Stack Architecture
- **Modern Jamstack Paradigm**: Master the architecture separating client presentation (Vue.js SPA) from persistence (Azure SQL) using cloud-native managed application gateways (Azure Static Web Apps).
- **Zero-Code CRUD Elimination**: Understand how Data API builder (DAB) eliminates the need for maintaining boilerplate controller code, object-relational mappers (ORMs), or traditional CRUD REST APIs.

### 3.2 Module 2: Cloud Infrastructure & Database Provisioning
- **Azure CLI Automation**: Gain proficiency in provisioning core infrastructure using the Azure CLI (`az cli`):
  - Resource group creation (`cardiff-serverless-days`).
  - Azure Static Web App creation (`cardiff-serverless-days-webapp`).
  - Azure SQL logical server creation (`cardiff-serverless-days-db<rng>`) and database initialization (`TodoDB`).
- **Security & Network Configuration**:
  - Configuring server-level firewall rules (`AllowAllWindowsAzureIps`) to enable inbound connectivity from Azure services.
  - Setting Microsoft Entra ID (Azure Active Directory) administrators via `az sql server ad-admin create` using signed-in user object IDs.
- **Least-Privilege Database Security Pattern**:
  - Distinguish between **administrative deployment credentials** (used by CI/CD to apply DDL schema migrations) and **runtime least-privilege database user credentials**.
  - Provision and configure the dedicated runtime user `todo_dab_user` (with password `rANd0m_PAzzw0rd!`) in [Script.PostDeployment.sql](file:///home/admin_owaino_altostrat_com/.ai-sdlc/projects/cardiff-serverless-days-workshop/.worktrees/run-2026082514030770/database/TodoDB/Script.PostDeployment.sql) and link it securely in Static Web Apps Database Connections.

### 3.3 Module 3: Automated CI/CD, Multi-Branch & Preview Environments
- **GitHub Secrets Management**: Configure the 6 essential repository secrets required for automated multi-branch deployments:
  1. `AZURE_CLIENT_ID`: Service Principal application client ID for Azure authentication.
  2. `AZURE_CLIENT_SECRET`: Service Principal client secret credential.
  3. `AZURE_TENANT_ID`: Microsoft Entra tenant ID.
  4. `SUBSCRIPTION_ID`: Azure subscription identifier.
  5. `AZURE_STATIC_WEB_APPS_API_TOKEN`: Deployment API token for Azure Static Web Apps.
  6. `AZURE_SQL_CONNECTION_STRING`: ADO.NET connection string targeting `TodoDB` on `cardiff-serverless-days-db<rng>` with DDL admin permissions.
- **Service Principal Role-Based Access Control (RBAC)**: Configure a Service Principal (`serverless-days-cardiff-2023-sp`) with `Contributor` role assignment scoped to the resource group or subscription.
- **Multi-Branch CI/CD Triggers**: Implement declarative workflow triggers in GitHub Actions supporting `workflow_dispatch`, branch pushes (`main`, `inprogress`), and pull requests (`[opened, synchronize, reopened, closed]`).
- **Automated Pull-Request Staging Previews**: Leverage Azure SWA staging environments that automatically deploy isolated preview URLs on pull requests, enabling end-to-end acceptance testing prior to merging to `main`.

### 3.4 Module 4: Database-as-an-API & Declarative Access Control
- **Declarative DAB Configuration**: Configure SWA Database Connections using [staticwebapp.database.config.json](file:///home/admin_owaino_altostrat_com/.ai-sdlc/projects/cardiff-serverless-days-workshop/.worktrees/run-2026082514030770/swa-db-connections/staticwebapp.database.config.json) to declare entity models, source SQL tables (`dbo.todos`), and exposed endpoints.
- **Declarative Role-Based Access Control (RBAC)**:
  - Configure `anonymous` role access for public operations.
  - Configure `authenticated` role access linked to GitHub identity for personalized CRUD actions.
  - Implement field-level security and row-level ownership mapping based on user claims.
- **Dual API Surface (REST & GraphQL)**:
  - Utilize auto-generated REST endpoints at `/data-api/rest/Todo` supporting standard HTTP verbs (`GET`, `POST`, `PUT`, `PATCH`, `DELETE`).
  - Explore GraphQL schemas and interactive queries exposed at `/data-api/graphql`.

### 3.5 Module 5: End-to-End Feature Development & Schema Evolution
- **Database Schema Migration**:
  - Extend table definitions in [dbo.todos.sql](file:///home/admin_owaino_altostrat_com/.ai-sdlc/projects/cardiff-serverless-days-workshop/.worktrees/run-2026082514030770/database/TodoDB/Tables/dbo.todos.sql) to add `[inprogress] [bit] NOT NULL`.
  - Establish column default constraints via `ALTER TABLE [dbo].[todos] ADD DEFAULT ((0)) FOR [inprogress]` to allow non-nullable column insertions through DAB without explicit payload omission errors.
- **Seed Data Lifecycle**: Update post-deployment scripts in [Script.PostDeployment.sql](file:///home/admin_owaino_altostrat_com/.ai-sdlc/projects/cardiff-serverless-days-workshop/.worktrees/run-2026082514030770/database/TodoDB/Script.PostDeployment.sql) to populate initial `inprogress` boolean values across seed records.
- **Client Application Integration**:
  - Update [ToDoList.vue](file:///home/admin_owaino_altostrat_com/.ai-sdlc/projects/cardiff-serverless-days-workshop/.worktrees/run-2026082514030770/client/src/components/ToDoList.vue) to incorporate `inprogress` item status toggles, reactive styling classes, and status filtering (`#/inprogress`).
  - Invoke auto-generated DAB endpoints with HTTP `PATCH` requests targeting `/data-api/rest/Todo/id/{id}` with partial JSON payloads (`{ inprogress: todo.inprogress, order: todo.order }`).

### 3.6 Module 6: Serverless API Extensibility & Advanced Tracks
- **Managed Azure Functions**: Implement managed serverless HTTP endpoints such as `/api/helloworld` co-located in the `/api` directory and exposed under the SWA gateway.
- **Client Identity Propagation**: Transmit Easy Auth authentication context (`userDetails` and `clientPrincipal` headers) from the Vue.js frontend into serverless backend functions.
- **Local Developer Experience**: Configure local emulation using `@azure/static-web-apps-cli` (`swa init`, `swa start`) paired with Azure Functions Core Tools (`func`) to simulate frontend, backend, and database connectivity locally.
- **Bring-Your-Own-Functions (BYOF)**: Architectural pattern decoupling Azure Functions into independent standalone Azure Function App resources linked directly into Azure Static Web Apps.

---

## 4. Concrete Deliverables & Verification Checklist

Participants completing the workshop produce the following verifiable artifacts:

- [x] **Repository & CI/CD Setup**:
  - Forked repository containing client code, database SQL project, DAB configuration, and GitHub Actions workflows.
  - 6 configured GitHub Actions Secrets: `AZURE_CLIENT_ID`, `AZURE_CLIENT_SECRET`, `AZURE_TENANT_ID`, `SUBSCRIPTION_ID`, `AZURE_STATIC_WEB_APPS_API_TOKEN`, and `AZURE_SQL_CONNECTION_STRING`.
  - Service Principal configured with `Contributor` role over the resource group.
- [x] **Cloud Infrastructure**:
  - Resource group `cardiff-serverless-days`.
  - Azure Static Web App `cardiff-serverless-days-webapp`.
  - Azure SQL logical server `cardiff-serverless-days-db<rng>` with `AllowAllWindowsAzureIps` firewall rule and Microsoft Entra ID admin.
  - Azure SQL Database `TodoDB` deployed via DACPAC action.
- [x] **Secure Runtime Database Connection**:
  - Static Web App Database Connection configured using least-privilege user `todo_dab_user` (password `rANd0m_PAzzw0rd!`).
  - Declarative configuration via [staticwebapp.database.config.json](file:///home/admin_owaino_altostrat_com/.ai-sdlc/projects/cardiff-serverless-days-workshop/.worktrees/run-2026082514030770/swa-db-connections/staticwebapp.database.config.json).
- [x] **Production Application Deployment**:
  - Live Vue.js application hosted on Azure Static Web Apps.
  - Integrated GitHub Easy Auth for authenticated user sessions.
  - Interactive CRUD operations communicating over auto-generated REST (`/data-api/rest/Todo`) and GraphQL (`/data-api/graphql`) endpoints.
- [x] **Feature Branch (`inprogress`) & Preview Environment**:
  - Schema extension in [dbo.todos.sql](file:///home/admin_owaino_altostrat_com/.ai-sdlc/projects/cardiff-serverless-days-workshop/.worktrees/run-2026082514030770/database/TodoDB/Tables/dbo.todos.sql) adding `[inprogress] [bit] NOT NULL` with default constraint `DEFAULT ((0))`.
  - Seed data migration updated in [Script.PostDeployment.sql](file:///home/admin_owaino_altostrat_com/.ai-sdlc/projects/cardiff-serverless-days-workshop/.worktrees/run-2026082514030770/database/TodoDB/Script.PostDeployment.sql).
  - Frontend component updates in [ToDoList.vue](file:///home/admin_owaino_altostrat_com/.ai-sdlc/projects/cardiff-serverless-days-workshop/.worktrees/run-2026082514030770/client/src/components/ToDoList.vue) supporting status toggles and filtering.
  - Isolated staging/preview environment deployed automatically by Azure SWA on pull request.
- [x] **Serverless API Extensions**:
  - Managed `/api/helloworld` Azure Function endpoint integrated into the Vue.js frontend with user identity context propagation.
  - Exploration of GraphQL query capabilities and Bring-Your-Own-Functions (`BYOF`) standalone backend architectures.
