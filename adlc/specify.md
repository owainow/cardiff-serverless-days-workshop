# Specification: Workshop Learning Outcomes & Deliverables Documentation

## 1. Objective
Add a dedicated documentation file, `OUTCOMES.md`, to the repository root that outlines the learning outcomes, technical proficiencies gained, and concrete deliverables produced by completing the Cardiff Serverless Days Azure Workshop.

---

## 2. Background & Motivation
The workshop repository guides attendees through building, deploying, and extending a full-stack serverless Todo application using Azure Static Web Apps (SWA), Azure SQL Database, Data API builder (DAB), and Azure Functions. While [`README.md`](file:///home/admin_owaino_altostrat_com/.ai-sdlc/projects/cardiff-serverless-days-workshop/.worktrees/run-2026082514030770/README.md) contains step-by-step technical instructions, there is currently no standalone document summarizing the structured learning outcomes, architectural tracks, or concrete deliverable verification checklist for attendees.

---

## 3. Scope & Target File
- **Target File**: `OUTCOMES.md` (root directory)
- **Primary Heading**: `# Cardiff Serverless Days Workshop: Learning Outcomes & Deliverables`

---

## 4. Key Requirements & Content Specifications

### 4.1 Target Audience & Workshop Overview
- Clear statement of workshop goals and architectural stack:
  - **Frontend**: [Vue.js](file:///home/admin_owaino_altostrat_com/.ai-sdlc/projects/cardiff-serverless-days-workshop/.worktrees/run-2026082514030770/client/package.json) Single Page Application (SPA) with Vite.
  - **Hosting & CI/CD**: Azure Static Web Apps (SWA) and GitHub Actions.
  - **Data Layer & API Engine**: Azure SQL Database integrated with Azure Static Web Apps Database Connections powered by Data API builder (DAB) exposing REST and GraphQL endpoints.
  - **Identity & Security**: Easy Auth configured with GitHub Identity Provider (IDP) and DAB role-based authorization policies (`anonymous` vs `authenticated`).
  - **Serverless API Extensibility**: Managed Azure Functions HTTP endpoints and Bring-Your-Own-Functions (BYOF) standalone architectures.

### 4.2 Learning Outcomes
The document must detail the specific knowledge and skills acquired across the workshop modules:
1. **Serverless Full-Stack Architecture**:
   - Understanding Jamstack and modern serverless web architectures on Azure.
   - Eliminating boilerplate CRUD API code using Data API builder directly over Azure SQL.
2. **Cloud Infrastructure & Provisioning**:
   - Creating resource groups (`cardiff-serverless-days`), Azure Static Web Apps, and Azure SQL logical servers (`cardiff-serverless-days-db<rng>`) hosting the `TodoDB` database using Azure CLI (`az cli`).
   - Configuring Azure SQL firewall rules, Active Directory (Entra ID) administrators, and Service Principals with RBAC.
3. **Automated CI/CD & Preview Environments**:
   - Configuring required GitHub repository secrets: `AZURE_CLIENT_ID`, `AZURE_CLIENT_SECRET`, `AZURE_TENANT_ID`, `SUBSCRIPTION_ID`, `AZURE_STATIC_WEB_APPS_API_TOKEN`, and `AZURE_SQL_CONNECTION_STRING`.
   - Understanding GitHub Actions workflow automation for production deployments and isolated staging/preview pull-request environments.
4. **Database-as-an-API & Declarative Access Control**:
   - Connecting SWA database connections to Azure SQL using DAB configuration ([`swa-db-connections/staticwebapp.database.config.json`](file:///home/admin_owaino_altostrat_com/.ai-sdlc/projects/cardiff-serverless-days-workshop/.worktrees/run-2026082514030770/swa-db-connections/staticwebapp.database.config.json)).
   - Applying granular entity-level permissions, field-level access, and user identity mapping (`authenticated` vs `anonymous`).
   - Exploring auto-generated REST endpoints (`/data-api/rest/*`) and GraphQL endpoints (`/data-api/graphql`).
5. **End-to-End Feature Development & Schema Evolution**:
   - Implementing schema updates in SQL Server DDL ([`database/TodoDB/Tables/dbo.todos.sql`](file:///home/admin_owaino_altostrat_com/.ai-sdlc/projects/cardiff-serverless-days-workshop/.worktrees/run-2026082514030770/database/TodoDB/Tables/dbo.todos.sql)) and post-deployment scripts ([`database/TodoDB/Script.PostDeployment.sql`](file:///home/admin_owaino_altostrat_com/.ai-sdlc/projects/cardiff-serverless-days-workshop/.worktrees/run-2026082514030770/database/TodoDB/Script.PostDeployment.sql)).
   - Specifying non-nullable column default constraints (`ALTER TABLE [dbo].[todos] ADD DEFAULT ((0)) FOR [inprogress]`) to ensure seamless frontend insertions via DAB without default value omission errors.
   - Consuming auto-generated DAB REST endpoints (`PATCH`, `GET`, `POST`, `DELETE`) from Vue.js components.
6. **Serverless API Extension & Advanced Architectural Tracks**:
   - Creating and deploying managed Azure Functions HTTP endpoints within Azure Static Web Apps.
   - Calling managed APIs with authenticated user context (`userDetails`) from client components.
   - Configuring local developer tooling with SWA CLI (`swa`) and Azure Functions Core Tools (`func`).
   - Exploring Bring-Your-Own-Functions (`BYOF`) to link standalone Azure Functions backend resources.

### 4.3 Concrete Deliverables & Milestones
The document must provide a checklist of artifacts and running systems built during the workshop:
- [x] **Forked & Cloned Repository**: Personal Git repository configured with CI/CD workflows and all required secrets (`AZURE_CLIENT_ID`, `AZURE_CLIENT_SECRET`, `AZURE_TENANT_ID`, `SUBSCRIPTION_ID`, `AZURE_STATIC_WEB_APPS_API_TOKEN`, `AZURE_SQL_CONNECTION_STRING`).
- [x] **Provisioned Azure Resources**: Resource group `cardiff-serverless-days`, Azure Static Web App, and Azure SQL Logical Server (`cardiff-serverless-days-db<rng>`) hosting the `TodoDB` database.
- [x] **Live Deployed Todo Web App**: Fully functional production Vue.js application deployed to Azure Static Web Apps with Easy Auth GitHub authentication.
- [x] **Integrated Data API Builder Backend**: Zero-code REST and GraphQL APIs exposing CRUD operations over Azure SQL table `dbo.todos`.
- [x] **In-Progress Feature Branch**: Custom feature branch `inprogress` showcasing:
  - Database schema extension (`inprogress` `BIT` column with default constraint `DEFAULT ((0))`).
  - Updated post-deployment seed scripts (`Script.PostDeployment.sql`).
  - Updated Vue.js UI ([`ToDoList.vue`](file:///home/admin_owaino_altostrat_com/.ai-sdlc/projects/cardiff-serverless-days-workshop/.worktrees/run-2026082514030770/client/src/components/ToDoList.vue)) with toggle controls and status filtering.
  - Working isolated preview environment generated by Azure SWA on pull request.
- [x] **Managed & Standalone Serverless Function Extensions**: Working `/api/helloworld` HTTP endpoint invoked by the client application with user details, alongside GraphQL querying and Bring-Your-Own-Functions (`BYOF`) architecture tracks.

---

## 5. Acceptance Criteria
1. **Document Location & Naming**: File `OUTCOMES.md` exists in the repository root.
2. **Header Matching**: Exact top-level heading must match `# Cardiff Serverless Days Workshop: Learning Outcomes & Deliverables`.
3. **Completeness**: Document covers all architectural layers (Frontend, SWA, DAB REST/GraphQL, SQL Server/Database, CI/CD secrets including `SUBSCRIPTION_ID`, Easy Auth, Managed Azure Functions, and BYOF tracks) and aligns directly with [`README.md`](file:///home/admin_owaino_altostrat_com/.ai-sdlc/projects/cardiff-serverless-days-workshop/.worktrees/run-2026082514030770/README.md).
4. **Formatting & Structure**: Clean GitHub Flavored Markdown with structured headings, checklists, and documentation links.
