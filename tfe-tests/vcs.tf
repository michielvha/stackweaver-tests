# Azure OIDC Configuration Tests
# https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/azure_oidc_configuration

resource "tfe_azure_oidc_configuration" "test" {
  organization    = var.organization
  client_id       = "8b9af9f6-6d1c-4218-b816-47deff648ed6"
  subscription_id = "d4dee7d6-6053-45f0-ace0-af83e384e552"
  tenant_id       = "434b720d-f80a-4de1-aad9-d29e655c493c"
}

output "azure_oidc_configuration_id" {
  value = tfe_azure_oidc_configuration.test.id
}
