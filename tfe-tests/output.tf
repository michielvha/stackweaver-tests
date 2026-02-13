// outputs
output "team_id" {
  description = "The ID of the created team"
  value       = tfe_team.test_team.id
}

output "team_name" {
  description = "The name of the created team"
  value       = tfe_team.test_team.name
}

output "organization_membership_id" {
  description = "The ID of the created organization membership"
  value       = tfe_organization_membership.test_member.id
}

output "team_organization_member_id" {
  description = "The ID of the team organization member relationship"
  value       = tfe_team_organization_member.test_team_member.id
}

output "team_organization_members_ids" {
  description = "The IDs of the team organization members relationships"
  value       = tolist(tfe_team_organization_members.test_team_members_1.organization_membership_ids)
}

// Self-hosted runner workspace outputs
output "selfhosted_runner_test_workspace_id" {
  description = "ID of the VCS-backed self-hosted runner test workspace"
  value       = tfe_workspace.selfhosted-runner-test.id
}

output "selfhosted_runner_cli_workspace_id" {
  description = "ID of the CLI-driven self-hosted runner test workspace"
  value       = tfe_workspace.selfhosted-runner-cli.id
}

output "agent_pool_id" {
  description = "ID of the test agent pool"
  value       = tfe_agent_pool.test-agent-pool.id
}