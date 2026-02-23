# Get current Azure context
data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

# Create Azure AD Application
resource "azuread_application" "stackweaver" {
  display_name = local.app_name
  description  = "Application for Stackweaver workload identity federation"
}

# Create Service Principal
resource "azuread_service_principal" "stackweaver" {
  client_id                    = azuread_application.stackweaver.client_id
  app_role_assignment_required = false
  description                  = "Service Principal for Stackweaver workload identity federation"
}

# Create Federated Identity Credentials (one for plan, one for apply, for each workspace)
resource "azuread_application_federated_identity_credential" "stackweaver" {
  for_each = local.workspace_credentials

  application_id = azuread_application.stackweaver.id
  display_name   = each.value.display_name
  description    = "Federated credential for Stackweaver workload identity federation workspace: ${each.value.workspace} (${each.value.run_phase})"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://stackweaver.vhco.pro"
  subject        = each.value.subject
}

# Assign roles to the service principal
resource "azurerm_role_assignment" "stackweaver" {
  for_each = { for idx, ra in var.role_assignments : idx => ra }

  scope                = each.value.scope != null ? each.value.scope : data.azurerm_subscription.current.id
  role_definition_name = each.value.role
  principal_id         = azuread_service_principal.stackweaver.object_id
}