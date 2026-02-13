resource "tfe_organization" "test-organization" {
  name  = "stackweaver-tests-1"
  email = "admin@zitadel.localhost"
}

resource "tfe_agent_pool" "test-agent-pool" {
  name         = "my-agent-pool-name"
  organization = "main"
  organization_scoped = true
}

data "tfe_project" "default-project" {
  name         = "default"
  organization = "main"
}

resource "tfe_agent_pool_allowed_projects" "allowed_projects" {
  agent_pool_id         = tfe_agent_pool.test-agent-pool.id
  allowed_project_ids   = [data.tfe_project.default-project.id]
}

data "tfe_workspace" "test-workspace" {
  name         = "stackweaver-tests-main"
  organization = "main"
}

data "tfe_workspace" "mikeshop-api" {
  name         = "mikeshop-api"
  organization = "main"
}

resource "tfe_agent_pool_allowed_workspaces" "allowed_workspaces" {
  agent_pool_id         = tfe_agent_pool.test-agent-pool.id
  allowed_workspace_ids = [data.tfe_workspace.test-workspace.id]
}

// Ensure permissions are assigned second
resource "tfe_agent_pool_excluded_workspaces" "excluded" {
  agent_pool_id          = tfe_agent_pool.test-agent-pool.id
  excluded_workspace_ids = [data.tfe_workspace.mikeshop-api.id]
}

resource "tfe_workspace_settings" "test-settings" {
  workspace_id   = data.tfe_workspace.test-workspace.id
  agent_pool_id  = tfe_agent_pool.test-agent-pool.id
  execution_mode = "agent"
}

// ============================================================================
// Workspace Creation via TFE Provider (VCS-backed)
// Tests: tfe_workspace + tfe_workspace_settings for self-hosted runners
// https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace
// https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace_settings
// ============================================================================

// Create a VCS-backed workspace pointing to the stackweaver-test repo
// Uses oauth_token_id which maps to StackWeaver's VCS Connection UUID
resource "tfe_workspace" "selfhosted-runner-test" {
  name              = "selfhosted-runner-test"
  organization      = var.organization
  project_id        = data.tfe_project.default-project.id
  description       = "Test workspace for self-hosted Terraform runner via TFE provider"
  terraform_version = "1.13.0"
  auto_apply        = false
  queue_all_runs    = false
  working_directory = ""

  vcs_repo {
    identifier                 = "michielvha/stackweaver-tests"
    branch                     = "main"
    github_app_installation_id = "94942361"
  }
}

// Configure the workspace to use agent execution mode with our test agent pool
resource "tfe_workspace_settings" "selfhosted-runner-test-settings" {
  workspace_id   = tfe_workspace.selfhosted-runner-test.id
  agent_pool_id  = tfe_agent_pool.test-agent-pool.id
  execution_mode = "agent"
}

// Create a second workspace without VCS (CLI/API-driven) for comparison testing
resource "tfe_workspace" "selfhosted-runner-cli" {
  name              = "selfhosted-runner-cli"
  organization      = var.organization
  project_id        = data.tfe_project.default-project.id
  description       = "CLI-driven workspace for self-hosted runner testing"
  terraform_version = "1.13.0"
  auto_apply        = true
  queue_all_runs    = false
}

// Configure the CLI workspace to also use agent mode
resource "tfe_workspace_settings" "selfhosted-runner-cli-settings" {
  workspace_id   = tfe_workspace.selfhosted-runner-cli.id
  agent_pool_id  = tfe_agent_pool.test-agent-pool.id
  execution_mode = "agent"
}