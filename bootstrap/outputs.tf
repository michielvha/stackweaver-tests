output "client_id" {
  description = "Application (client) ID - use for stackweaver_AZURE_RUN_CLIENT_ID"
  value       = azuread_application.stackweaver.client_id
}

output "subscription_id" {
  description = "Subscription ID - use for ARM_SUBSCRIPTION_ID"
  value       = data.azurerm_subscription.current.subscription_id
}

output "tenant_id" {
  description = "Tenant ID - use for ARM_TENANT_ID"
  value       = data.azurerm_client_config.current.tenant_id
}

output "terraform_cloud_variables" {
  description = "Variables to set in Terraform Cloud workspace"
  value = {
    stackweaver_AZURE_PROVIDER_AUTH = "true"
    stackweaver_AZURE_RUN_CLIENT_ID = azuread_application.stackweaver.client_id
    ARM_SUBSCRIPTION_ID     = data.azurerm_subscription.current.subscription_id
    ARM_TENANT_ID           = data.azurerm_client_config.current.tenant_id
  }
}

output "subject_claim" {
  description = "The subject claims used for the federated credentials"
  value       = { for k, v in local.workspace_credentials : k => v.subject }
}

output "federated_credentials" {
  description = "Map of all created federated credentials"
  value = {
    for k, v in local.workspace_credentials : k => {
      workspace    = v.workspace
      run_phase    = v.run_phase
      subject      = v.subject
      display_name = v.display_name
    }
  }
}