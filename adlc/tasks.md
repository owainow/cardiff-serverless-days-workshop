# Tasks: Workshop Learning Outcomes & Deliverables Documentation

This task list guides the implementation of [`OUTCOMES.md`](file:///home/admin_owaino_altostrat_com/.ai-sdlc/projects/cardiff-serverless-days-workshop/.worktrees/run-2026082514030770/OUTCOMES.md) in the repository root according to [`adlc/specify.md`](file:///home/admin_owaino_altostrat_com/.ai-sdlc/projects/cardiff-serverless-days-workshop/.worktrees/run-2026082514030770/adlc/specify.md) and [`adlc/plan.md`](file:///home/admin_owaino_altostrat_com/.ai-sdlc/projects/cardiff-serverless-days-workshop/.worktrees/run-2026082514030770/adlc/plan.md).

---

## Task 1: Create Document Foundation & Architecture Matrix
- [ ] Create [`OUTCOMES.md`](file:///home/admin_owaino_altostrat_com/.ai-sdlc/projects/cardiff-serverless-days-workshop/.worktrees/run-2026082514030770/OUTCOMES.md) in the repository root.
- [ ] Set exact level 1 heading: `# Cardiff Serverless Days Workshop: Learning Outcomes & Deliverables`.
- [ ] Author **Section 1: Executive Summary & Workshop Overview** explaining the workshop goals, full-stack Jamstack paradigm, and serverless application topology.
- [ ] Author **Section 2: Architectural Stack & Technology Matrix** featuring a table mapping:
  - **Frontend**: [Vue.js](file:///home/admin_owaino_altostrat_com/.ai-sdlc/projects/cardiff-serverless-days-workshop/.worktrees/run-2026082514030770/client/package.json) SPA with Vite.
  - **Hosting & Platform**: Azure Static Web Apps (SWA).
  - **Data Layer**: Azure SQL Database (`TodoDB`).
  - **API Engine**: Data API builder (DAB) / SWA Database Connections ([`swa-db-connections/staticwebapp.database.config.json`](file:///home/admin_owaino_altostrat_com/.ai-sdlc/projects/cardiff-serverless-days-workshop/.worktrees/run-2026082514030770/swa-db-connections/staticwebapp.database.config.json)).
  - **Identity & Access**: Easy Auth with GitHub IDP & DAB role-based authorization policies.
  - **Serverless API Extensibility**: Managed Azure Functions HTTP endpoints & Bring-Your-Own-Functions (BYOF).
  - **CI/CD & Automation**: GitHub Actions multi-branch workflows and pull-request staging previews.

---

## Task 2: Document Detailed Module Learning Outcomes
- [ ] **Section 3.1: Serverless Full-Stack Architecture**: Detail modern Azure Jamstack principles and elimination of CRUD API boilerplate via Data API builder.
- [ ] **Section 3.2: Cloud Infrastructure & Provisioning**: Document resource group (`cardiff-serverless-days`), SWA, and Azure SQL logical server (`cardiff-serverless-days-db<rng>`) provisioning via Azure CLI, firewall rules (`AllowAllWindowsAzureIps`), Entra ID admin configuration, and least-privilege runtime database user pattern (`todo_dab_user` with password `rANd0m_PAzzw0rd!`).
- [ ] **Section 3.3: Automated CI/CD, Multi-Branch & Preview Environments**: Detail the 6 required GitHub repository secrets (`AZURE_CLIENT_ID`, `AZURE_CLIENT_SECRET`, `AZURE_TENANT_ID`, `SUBSCRIPTION_ID`, `AZURE_STATIC_WEB_APPS_API_TOKEN`, `AZURE_SQL_CONNECTION_STRING`), Contributor Service Principal RBAC, multi-branch workflow triggers (`push` on `main`/`inprogress`, `pull_request` triggers), and automated PR staging preview environments.
- [ ] **Section 3.4: Database-as-an-API & Declarative Access Control**: Explain [`swa-db-connections/staticwebapp.database.config.json`](file:///home/admin_owaino_altostrat_com/.ai-sdlc/projects/cardiff-serverless-days-workshop/.worktrees/run-2026082514030770/swa-db-connections/staticwebapp.database.config.json), entity mapping, RBAC permissions (`anonymous` vs `authenticated`), field-level security, and auto-generated REST (`/data-api/rest/*`) and GraphQL (`/data-api/graphql`) endpoints.
- [ ] **Section 3.5: End-to-End Feature Development & Schema Evolution**: Detail database schema changes in [`database/TodoDB/Tables/dbo.todos.sql`](file:///home/admin_owaino_altostrat_com/.ai-sdlc/projects/cardiff-serverless-days-workshop/.worktrees/run-2026082514030770/database/TodoDB/Tables/dbo.todos.sql) introducing `[inprogress] BIT NOT NULL` with `DEFAULT ((0))`, post-deployment seed scripts in [`database/TodoDB/Script.PostDeployment.sql`](file:///home/admin_owaino_altostrat_com/.ai-sdlc/projects/cardiff-serverless-days-workshop/.worktrees/run-2026082514030770/database/TodoDB/Script.PostDeployment.sql), and frontend component updates in [`client/src/components/ToDoList.vue`](file:///home/admin_owaino_altostrat_com/.ai-sdlc/projects/cardiff-serverless-days-workshop/.worktrees/run-2026082514030770/client/src/components/ToDoList.vue).
- [ ] **Section 3.6: Serverless API Extensibility & Advanced Tracks**: Detail managed `/api/helloworld` Azure Function endpoint, client authentication context propagation (`userDetails` / `clientPrincipal`), local developer emulation with SWA CLI / Functions Core Tools, and Bring-Your-Own-Functions (`BYOF`) standalone architecture.

---

## Task 3: Author Concrete Deliverables & Verification Checklist
- [ ] **Section 4: Concrete Deliverables & Verification Checklist**: Implement a structured markdown checklist covering:
  - Configured repository with all 6 CI/CD secrets.
  - Provisioned Azure cloud resources.
  - Live deployed Vue.js web app with GitHub authentication.
  - Zero-code REST and GraphQL DAB backend over `dbo.todos`.
  - In-progress feature branch with SQL schema migration (`BIT`, `DEFAULT ((0))`), post-deployment scripts, UI updates, and PR preview deployment.
  - Managed `/api/helloworld` endpoint & BYOF architecture tracks.

---

## Task 4: Markdown Formatting & Verification
- [ ] Ensure formatting uses GitHub Flavored Markdown with clean headers, callouts, bullet points, and code spans.
- [ ] Verify that all required keywords and section references pass the verify commands.

```verify
test -f OUTCOMES.md
grep -Fq "# Cardiff Serverless Days Workshop: Learning Outcomes & Deliverables" OUTCOMES.md
grep -Fq "AZURE_CLIENT_ID" OUTCOMES.md
grep -Fq "AZURE_CLIENT_SECRET" OUTCOMES.md
grep -Fq "AZURE_TENANT_ID" OUTCOMES.md
grep -Fq "SUBSCRIPTION_ID" OUTCOMES.md
grep -Fq "AZURE_STATIC_WEB_APPS_API_TOKEN" OUTCOMES.md
grep -Fq "AZURE_SQL_CONNECTION_STRING" OUTCOMES.md
grep -Fq "todo_dab_user" OUTCOMES.md
grep -Fq "DEFAULT ((0))" OUTCOMES.md
grep -Fq "/api/helloworld" OUTCOMES.md
grep -Fq "staticwebapp.database.config.json" OUTCOMES.md
grep -Fq "ToDoList.vue" OUTCOMES.md
grep -Fq "Script.PostDeployment.sql" OUTCOMES.md
grep -Fq "dbo.todos.sql" OUTCOMES.md
```
